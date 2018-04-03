F1::
MouseGetPos, MouseX, MouseY
;MouseX = 42
;MouseY = 1020
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox, The color at the current cursor position is %color%. X Pos is: %MouseX% & Y Pos is: %MouseY%.
return