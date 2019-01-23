; according to https://autohotkey.com/board/topic/91350-need-help-on-rotation-script/
; After some experimenting on the matter i think i now understand how A_ThisHotkey and A_PriorHotkey works. E.g if 1 is your hotkey it becomes A_ThisHotkey when I press it and hold it down but when I release it, 1 becomes A_PriorHotkey. So A_TimeSinceThisHotkey is kinda missleading for me is it seems to be used to measure how long the keystroke was and act accordingly.

MButton::

if (A_PriorHotkey <> "MButton" or A_TimeSincePriorHotkey > 200) {
	send, {MButton Down}
	keywait, MButton
	send, {MButton up}
	return
}

return