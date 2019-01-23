#SingleInstance force
#Persistent

; Manage whether to allow mouse input and display cursor (and also faux cursor)
; Faux cursor is used for Games and similar applications, which may hide the cursor differently or every frame
global Mouse_Blocked := false
Main() {
	if (%Mouse_Blocked% = false) {
		Mouse_Blocked = true
		BlockInput MouseMove
		SystemCursor("Off")
	}
	else if (%Mouse_Blocked% = true) {
		Mouse_Blocked = false
		BlockInput MouseMoveOff
		SystemCursor("On")
	}
}

; code from https://autohotkey.com/docs/commands/DllCall.htm / http://www.autohotkey.com/forum/topic6107.html
SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
	static AndMask, XorMask, $, h_cursor
		,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
		, b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
		, h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
	if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
	{
		$ = h                                          ; active default cursors
		VarSetCapacity( h_cursor,4444, 1 )
		VarSetCapacity( AndMask, 32*4, 0xFF )
		VarSetCapacity( XorMask, 32*4, 0 )
		system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
		StringSplit c, system_cursors, `,
		Loop %c0%
		{
			h_cursor   := DllCall( "LoadCursor", "Ptr",0, "Ptr",c%A_Index% )
			h%A_Index% := DllCall( "CopyImage", "Ptr",h_cursor, "UInt",2, "Int",0, "Int",0, "UInt",0 )
			b%A_Index% := DllCall( "CreateCursor", "Ptr",0, "Int",0, "Int",0
			, "Int",32, "Int",32, "Ptr",&AndMask, "Ptr",&XorMask )
		}
	}
	if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
		$ = b  ; use blank cursors
	else
		$ = h  ; use the saved cursors

	Loop %c0%
	{
		h_cursor := DllCall( "CopyImage", "Ptr",%$%%A_Index%, "UInt",2, "Int",0, "Int",0, "UInt",0 )
		DllCall( "SetSystemCursor", "Ptr",h_cursor, "UInt",c%A_Index% )
	}
}

; setup the faux cursor
; code from https://autohotkey.com/board/topic/76879-show-a-little-image-that-always-follows-the-mouse/
CoordMode, Mouse, screen
Gui -Caption +LastFound +ToolWindow +AlwaysOnTop
Gui, Margin, 0, 0
Gui, Color, FFFFFF
Gui, Add, Picture, x0 y0 w-1 h20 +BackgroundTrans, cursor.png ; define picture and height
WinSet, Transcolor, FFFFFF ; set the picture's GUI window to be invisible
WinSet, ExStyle, +0x20 ; set the GUI window as click-through to not take focus

SetTimer runFakeCursor, 1 ; for some reason, SetTimer only calls a label and not a function...
runFakeCursor:
	FakeCursor()
return

FakeCursor() {
	if (%Mouse_Blocked% = false) {
		MouseGetPos, x, y
		Gui Show, x%x% y%y% NoActivate ; set the GUI window as NoActivate so as to not take focus every frame
	} else {
		Gui Cancel
	}
}

#c::Main() ; Win+C hotkey to toggle the cursor on and off.
