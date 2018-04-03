#SingleInstance force
#Persistent

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