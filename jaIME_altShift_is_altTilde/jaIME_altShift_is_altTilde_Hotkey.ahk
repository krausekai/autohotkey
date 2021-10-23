#SingleInstance force
#Persistent

SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; BUGS
; Alt-Shift hotkeys may break

; Fix alt-tab-shift
global altTabPressed := false
Tab() {
	altTabPressed = true
}
Alt() {
	altTabPressed = false
}

Main() {
	; Detect that Alt+Tab was not pressed
	if (%altTabPressed% = false) {
		; Send the command Alt+Tilde
		Send !{``}
	}
}

; See https://autohotkey.com/docs/Hotkeys.htm
~!LShift Up:: Main()
~*Tab:: Tab()
~*Alt:: Alt()