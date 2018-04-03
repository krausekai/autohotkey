#Persistent

/*
Persistent: Script won't end unless manually ended
xyz:: are Hotkeys (Eg: F1:: Hit F1 to start this script)
*/

F1::

/*
Check if the video is, or isn't playing (play, pause)
*/
colorNotPlaying = 0x121212
colorIsPlaying = 0x777777
playingIconX = 60
playingIconY = 920

/*
Has the video stopped playing entirely? If so, check for next video thumbnail preview
*/
colorVideoStopped = 0x1B1B1B
videoNotPlayingX = 330
videoNotPlayingY = 550

colorThumbnailPreview = 0x111111
thumbnailPreviewX = 1087
thumbnailPreviewY = 534

colorVideoLoading = 0x000000

ClickCount = 4
MoveSpeed = 20

/*
Get the pixel color at the specified x/y locations set above, and compare it's colors with those above
*/
PixelGetColor,currentColor,xPos,yPos, slow
PixelGetColor,currentColorTwo,xPosT,yPosT, slow

recording := false


Loop
{
/*
Program window may have focus stolen, if so, return it
Program Window is always on top, by window name "Offline Player"
*/
	IfWinNotActive, Offline Player
	{
		IfWinExist, Offline Player
			WinActivate 
	}
	WinSet, AlwaysOnTop, toggle, Offline Player

/*
STOP Loop
*/

	if (BreakLoop == 1) {
	  break 
	}

/*
Assign x/y locations
*/

	xPos := playingIconX
	yPos := playingIconY
	PixelGetColor,currentColor,xPos,yPos
	
	xPosT := thumbnailPreviewX
	yPosT := thumbnailPreviewY
	PixelGetColor,currentColorTwo,xPosT,yPosT
	
/*
START recording, if video is playing
*/

	if (currentColor == colorIsPlaying && currentColorTwo != colorVideoLoading) {
		if (recording == false){
			Send, {F2 1}
			recording := true
		}
	}

/*
STOP recording, if video has stopped
*/

	if (currentColor == colorNotPlaying || currentColor == colorVideoStopped || currentColorTwo == colorVideoLoading ) {
		if (recording == true){
			Send, {F2 1}
			recording := false
		}
	}

/*
Goto next video if available in playlist, else stop script
*/

	if (currentColor != colorIsPlaying && currentColor != colorNotPlaying){
		xPos := videoNotPlayingX
		yPos := videoNotPlayingY
		PixelGetColor,currentColor,xPos,yPos
		
		if (currentColor == colorVideoStopped) {
			/*
			goto next video in playlist
			*/
			if (currentColorTwo != colorThumbnailPreview && currentColorTwo != colorVideoStopped ) {
				MouseClick, left, thumbnailPreviewX, thumbnailPreviewY, ClickCount, MoveSpeed
			}
		}
		
		if (currentColorTwo == colorVideoStopped) {
			/*
			no more videos in playlist, stop this script!
			*/
			Send, {Esc}
		}
		
	}
	
sleep,250
}

Esc::
BreakLoop = 1

F9::Pause