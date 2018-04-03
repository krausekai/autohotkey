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
playingIconX = 42
playingIconY = 1020

/*
Has the video stopped playing entirely? If so, check for next video thumbnail preview
*/
colorVideoStopped = 0x0D0D0D
;left side pane replay button, if video has stopped
videoNotPlayingAX = 678
videoNotPlayingAY = 555
;middle replay button, if no more videos in the playlist exist
videoNotPlayingBX = 964
videoNotPlayingBY = 589

colorThumbnailPreview = 0x111111
colorNoThumbnailPreview = 0x0B0B0B
colorNoThumbnailPreviewTwo = 0x1B1B1B
thumbnailPreviewX = 1414
thumbnailPreviewY = 512

colorVideoLoading = 0x000000

ClickCount = 4
MoveSpeed = 20

/*
Get the pixel color at the specified x/y locations set above, and compare it's colors with those above
*/
PixelGetColor,currentColor,xPos,yPos, slow ;Video playing
PixelGetColor,currentColorTwo,xPosT,yPosT, slow ;Right pane Thumbnail, video loading
PixelGetColor,currentColorThree,xPosTH,yPosTH, slow ;Side & Middle pane replay (has video stopped)

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
	WinSet, AlwaysOnTop, On, Offline Player

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
	
	xPosTH := videoNotPlayingAX
	yPosTH := videoNotPlayingAY
	PixelGetColor,currentColorThree,xPosTH,yPosTH
	
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

	if (currentColor != colorIsPlaying || currentColorTwo == colorVideoLoading ) {
		if (recording == true){
			Send, {F2 1}
			recording := false
		}
	}

/*
Goto next video if available in playlist, else stop script
*/

	if (currentColor != colorIsPlaying && currentColor != colorNotPlaying){
		
		xPosTH := videoNotPlayingBX
		yPosTH := videoNotPlayingBY
		PixelGetColor,currentColorThree,xPosTH,yPosTH
		
			/*
			goto next video in playlist
			*/
		if (currentColorTwo != colorThumbnailPreview && currentColorTwo != colorVideoLoading) {
			if (currentColorTwo != colorNoThumbnailPreview && currentColorTwo != colorNoThumbnailPreviewTwo) {
				MouseClick, left, thumbnailPreviewX, thumbnailPreviewY, ClickCount, MoveSpeed
			}
		}
		
		if (currentColorThree == colorVideoStopped) {
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