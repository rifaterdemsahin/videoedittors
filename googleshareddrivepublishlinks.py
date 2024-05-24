import os.path
import google.auth
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# If modifying these SCOPES, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/drive.metadata.readonly', 'https://www.googleapis.com/auth/drive.file']

def authenticate():
    """Shows basic usage of the Drive v3 API.
    Lists the names and IDs of the first 10 files the user has access to.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())
    return creds

def list_files_in_folder(service, folder_id):
    results = service.files().list(
        q=f"'{folder_id}' in parents",
        pageSize=1000,
        fields="nextPageToken, files(id, name)"
    ).execute()
    items = results.get('files', [])
    if not items:
        print('No files found.')
        return []
    else:
        return items

def generate_publish_url(file_id):
    return f"https://drive.google.com/uc?export=view&id={file_id}"

def main():
    creds = authenticate()
    service = build('drive', 'v3', credentials=creds)

    folder_id = 'your-folder-id'  # Replace with your folder ID
    files = list_files_in_folder(service, folder_id)

    for file in files:
        publish_url = generate_publish_url(file['id'])
        print(f"File Name: {file['name']}\nPublish URL: {publish_url}\n")

if __name__ == '__main__':
    main()
