; - Detect whether the Keyboard has changed (or the hotkeys alt+shift have been pressed)
; - Detect whether it is the first time the Keyboard has changed in this application (even if application is reopened)
;		- Track programs the keyboard has been changed in
;		- Remove the program from memory if it has closed
;	- Once keyboard has changed to Jp for the first time (or alt+shift has been pressed for the first time), launch the command Alt+CapsLock

#SingleInstance force
#Persistent
;#NoTrayIcon

global Programs:= [""]
global ProgramsList:=

global Success:= true
AddProgram(program) {
	ProgramsLen:= Programs.Length()
	Success = true
	for index, element in Programs
	{
		; check for duplicates in array
		if (program = element) {
			Success = false
			break
		}
		; before pushing to the array
		else if (index >= ProgramsLen) {
			Programs.Push(program)
			;ProgramsList = %ProgramsList% %program%
			break
		}
	}
	;MsgBox, %Success% %ProgramsList%
	return %Success%
}

; Check whether the program has closed, and if so, remove it from Programs
ProgramRunning(program){
	Process, Exist, %program%
	return Errorlevel
}
CheckProgramLife() {
	for index, element in Programs
	{
		if (!ProgramRunning(element)) {
			Programs.Remove(index)
			;MsgBox, %element% removed
		}
	}
}
SetTimer, CheckProgramLife, 2000

Main() {
	sleep, 250
	; Get the current program and Locale
  SetFormat, Integer, H
  WinGet, WinID, ProcessName, A

	; Detect Current Locale
	English:= 0x4090C09
	Japanese:= 0x4110411
	ThreadID:= DllCall("GetWindowThreadProcessId", "Ptr", WinActive("A"), "Ptr", 0)
	InputLocaleID:= DllCall("GetKeyboardLayout", "Ptr", ThreadID, "Ptr", 0)

	; Detect that the current Locale is Japanese
	if (InputLocaleID = Japanese) {

		; Detect whether it is the first time starting the IME in this program
		ProgramAdded:= AddProgram(WinID)
		if (%ProgramAdded% = false) {
			return
		}

		; Default the IME from Romaji to Hiragana
		; Alt+CapsLock
		Send !{CapsLock}

	}

}

;SetTimer, Main, 2000

;~!LShift:: Main()
