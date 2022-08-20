#SingleInstance force
#Persistent

SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; ctrl+shift+d
^+D:: Run, %A_ProgramFiles%\Notepad++\notepad++.exe
