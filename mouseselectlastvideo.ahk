#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; Specify the folder to search
folderPath := "C:\Users\rifat\Videos"

latestFile := ""
latestTime := 0

Loop, Files, %folderPath%\*.mp4, FR
{
    fileTime := A_LoopFileTimeCreated
    ; Convert the file creation time to seconds since the epoch
    fileTime := StrReplace(fileTime, ":", "", A_LoopFileName)
    fileTime := StrReplace(fileTime, " ", "", A_LoopFileName)
    if (fileTime > latestTime)
    {
        latestTime := fileTime
        latestFile := A_LoopFileFullPath
    }
}

if (latestFile != "")
{
    ; Open the folder in File Explorer
    Run, % "explorer.exe /select," latestFile

    ; Wait for the Explorer window to open and stabilize
    WinWaitActive, ahk_class CabinetWClass, , 3
    Sleep, 1000

    ; Find the latest file in the Explorer window and select it
    ControlFocus, DirectUIHWND1, ahk_class CabinetWClass
    ControlSend, DirectUIHWND1, ^f, ahk_class CabinetWClass
    Sleep, 500
    Send, % latestFile
    Sleep, 500
    Send, {Enter}
    Sleep, 1000

    ; Ensure the file is selected
    Send, {Up}
    Sleep, 100
    Send, {Down}
    Sleep, 100

    ; Move the mouse to the selected file and click it to ensure it's ready to drag
    CoordMode, Mouse, Screen
    MouseMove, 100, 100 ; Arbitrary starting point to ensure mouse movement starts
    MouseClick, left
    MouseMove, 100, 100, 0 ; Move to the initial position
    ControlGetPos, x, y, w, h, DirectUIHWND1, A ; Get the position of the Explorer window
    MouseMove, x + 50, y + 150, 0 ; Move the mouse to the general area of the file (adjust as needed)
    MouseClick, left, x + 50, y + 150, 1, 0 ; Click to select the file (adjust as needed)
}
else
{
    MsgBox, No .mp4 files found in the specified folder.
}
