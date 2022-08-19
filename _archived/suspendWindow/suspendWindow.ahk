; note that certain processes cannot be suspended (game anti-cheat, DLL injected protections, etc)

#SingleInstance force
#Persistent

SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

cached_PID := null

Pause::
	; Cache the current window PID
	if (cached_PID == null || !IsProcessSuspended(cached_PID)) {
		WinGet, ID, ID, A
		WinGet, cached_PID, PID, ahk_id %ID%
	}

	; Then suspend/resume
	if (!IsProcessSuspended(cached_PID)) {
		SuspendProcess(cached_PID)
	}
	else {
		ResumeProcess(cached_PID)
	}
Return

SuspendProcess(pid) {
	hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "Int", pid)
	If (hProcess) {
		DllCall("ntdll.dll\NtSuspendProcess", "Int", hProcess)
		DllCall("CloseHandle", "Int", hProcess)
	}
}
ResumeProcess(pid) {
	hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "Int", pid)
	If (hProcess) {
		DllCall("ntdll.dll\NtResumeProcess", "Int", hProcess)
		DllCall("CloseHandle", "Int", hProcess)
	}
}
IsProcessSuspended(pid) {
	For thread in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Thread WHERE ProcessHandle = " pid) {
		If (thread.ThreadWaitReason == 5) {
			Return True
		}
	}
	Return False
}
