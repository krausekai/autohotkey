#SingleInstance force
CoordMode, Mouse, screen
Gui -Caption +LastFound +ToolWindow +AlwaysOnTop
Gui, Margin, 0, 0
Gui, Color, FFFFFF
Gui, Add, Picture, x0 y0 w-1 h50 +BackgroundTrans, arrow.jpg
WinSet, Transcolor, FFFFFF
WinSet, ExStyle, +0x20 ;set click through style
gosub, F1
return

F1:: SetTimer Draw, % (switch:= !switch) ? "20" : "-20"
Draw:
	If switch {
		MouseGetPos, x, y
		Gui Show, x%x% y%y% NoActivate
	} else {
		Gui Cancel
	}
return

esc::ExitApp
ExitApp

return