#SingleInstance force
#Persistent

SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; Source: https://superuser.com/a/1652616

#c::

winHandle := WinExist("A") ; The window to operate on

; Don't worry about how this part works. Just trust that it gets the 
; bounding coordinates of the monitor the window is on.
;--------------------------------------------------------------------------
VarSetCapacity(monitorInfo, 40), NumPut(40, monitorInfo)
monitorHandle := DllCall("MonitorFromWindow", "Ptr", winHandle, "UInt", 0x2)
DllCall("GetMonitorInfo", "Ptr", monitorHandle, "Ptr", &monitorInfo)
;--------------------------------------------------------------------------

workLeft      := NumGet(monitorInfo, 20, "Int") ; Left
workTop       := NumGet(monitorInfo, 24, "Int") ; Top
workRight     := NumGet(monitorInfo, 28, "Int") ; Right
workBottom    := NumGet(monitorInfo, 32, "Int") ; Bottom
WinGetPos,,, W, H, A
WinGet, Style, Style, A
If ( Style & 0x20000 ) ; WS_MINIMIZEBOX
{
    WinMove, A,, workLeft + (workRight - workLeft) // 2 - W // 2, workTop + (workBottom - workTop) // 2 - H // 2
}
