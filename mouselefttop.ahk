^3::
    ; Retrieve the number of monitors
    SysGet, MonitorCount, MonitorCount
    If (MonitorCount < 4) {
        MsgBox, You have less than 4 monitors connected.
        Return
    }

    ; Retrieve information for each monitor
    SysGet, Monitor1, Monitor, 1
    SysGet, Monitor2, Monitor, 2
    SysGet, Monitor3, Monitor, 3
    SysGet, Monitor4, Monitor, 4

    ; Display the coordinates of each monitor for debugging
    MsgBox, Monitor 1: Left=%Monitor1Left% Top=%Monitor1Top%`nMonitor 2: Left=%Monitor2Left% Top=%Monitor2Top%`nMonitor 3: Left=%Monitor3Left% Top=%Monitor3Top%`nMonitor 4: Left=%Monitor4Left% Top=%Monitor4Top%

    ; Assuming you want to move the mouse to coordinates (840, 238) on Monitor 1
    x := Monitor1Left + 840
    y := Monitor1Top + 238

    ; Display the calculated coordinates for debugging
    MsgBox, Moving mouse to X=%x% Y=%y% on Monitor 1

    ; Move the mouse to the specific coordinates on Monitor 1
    MouseMove, x, y
    Return
