; according to https://autohotkey.com/board/topic/91350-need-help-on-rotation-script/
; After some experimenting on the matter i think i now understand how A_ThisHotkey and A_PriorHotkey works. E.g if 1 is your hotkey it becomes A_ThisHotkey when I press it and hold it down but when I release it, 1 becomes A_PriorHotkey. So A_TimeSinceThisHotkey is kinda missleading for me is it seems to be used to measure how long the keystroke was and act accordingly.

#SingleInstance Force
SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

MButton::

if (A_PriorHotkey <> "MButton" or A_TimeSincePriorHotkey > 250) {
	send, {MButton Down}
	keywait, MButton
	send, {MButton up}
	return
}

return