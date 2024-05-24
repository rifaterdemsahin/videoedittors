import os.path
import logging
import google.auth
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# Configure logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s %(message)s')

# If modifying these SCOPES, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/drive.metadata.readonly', 'https://www.googleapis.com/auth/drive.file']

def authenticate():
    logging.debug("Starting authentication process")
    creds = None
    try:
        if os.path.exists('token.json'):
            logging.debug("token.json found")
            creds = Credentials.from_authorized_user_file('token.json', SCOPES)
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                logging.debug("Refreshing expired credentials")
                creds.refresh(Request())
            else:
                logging.debug("Fetching new credentials using client secrets file")
                flow = InstalledAppFlow.from_client_secrets_file(
                    'credentials.json', SCOPES)
                creds = flow.run_local_server(port=0)
            with open('token.json', 'w') as token:
                token.write(creds.to_json())
                logging.debug("Credentials saved to token.json")
    except Exception as e:
        logging.error("Error during authentication: %s", e)
        raise
    return creds

def list_files_in_folder(service, folder_id):
    logging.debug("Listing files in folder: %s", folder_id)
    try:
        query = f"'{folder_id}' in parents"
        logging.debug("Query: %s", query)
        results = service.files().list(
            q=query,
            pageSize=1000,
            fields="nextPageToken, files(id, name)",
            supportsAllDrives=True,
            includeItemsFromAllDrives=True
        ).execute()
        logging.debug("Response from API: %s", results)
        items = results.get('files', [])
        if not items:
            logging.info('No files found.')
            return []
        else:
            logging.debug("Files found: %s", items)
            return items
    except Exception as e:
        logging.error("Error listing files in folder: %s", e)
        raise

def generate_publish_url(file_id):
    return f"https://drive.google.com/uc?export=view&id={file_id}"

def main():
    try:
        creds = authenticate()
        service = build('drive', 'v3', credentials=creds)

        folder_id = '1ghQYqoD-geKR8DWILuKYNo63mIcyYLwV'  # Replace with your folder ID
        files = list_files_in_folder(service, folder_id)

        for file in files:
            publish_url = generate_publish_url(file['id'])
            logging.info(f"File Name: {file['name']}\nPublish URL: {publish_url}\n")
    except Exception as e:
        logging.error("An error occurred in the main process: %s", e)

if __name__ == '__main__':
    main()
