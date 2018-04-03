#SingleInstance force
#Persistent

; BUGS
; Alt key does not correctly hold down:
;		1. Cannot crouch in games;
;		2. Program menu bars may not close

Main() {
	; Detect the Alt+Shift keys
	if (GetKeyState("Shift","P")) {
		; Fix "Send" weirdness...
		SetKeyDelay, 150
		; Send the command Alt+Tilde
		Send !{``}
	}
	; Otherwise, use Alt normally
	else {
		SetKeyDelay, 0
		Send {Alt Down}
		KeyWait, Alt
		Send {Alt Up}
	}
}

*Alt:: Main() ; Use * to correctly query modifier keys with Alt and GetKeyState