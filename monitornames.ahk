; This script lists the information about all connected monitors
#Persistent
SysGet, MonitorCount, MonitorCount
MsgBox, Number of monitors detected: %MonitorCount%

Loop, %MonitorCount%
{
    SysGet, MonitorName, MonitorName, %A_Index%
    SysGet, Monitor, Monitor, %A_Index%
    MsgBox, Monitor #%A_Index%`nName: %MonitorName%`nLeft: %MonitorLeft%`nTop: %MonitorTop%`nRight: %MonitorRight%`nBottom: %MonitorBottom%
}
