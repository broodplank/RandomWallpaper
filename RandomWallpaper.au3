#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=RandomWallpaperChanger.exe
#AutoIt3Wrapper_Res_Description=broodplank.net
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; Random Wallpaper from wallhaven.cc
; Created by broodplank
; Copyright 2014 broodplank.net - All Rights Reserved


Opt("TrayAutoPause", 0)

$version = "1.2"

HotKeySet("^!s", "SaveWallpaper")
HotKeySet("^!p", "PauseLoop")
HotKeySet("^!c", "_ContinueLoop")
HotKeySet("^!n", "NextWallpaper")
HotKeySet("^!i", "SetInterval")
HotKeySet("^!x", "Quit")


MsgBox(0, "Random Wallpaper Changer", "Hotkeys:" & @CRLF & @CRLF & "- Save Wallpaper:   Control+Alt+S" & @CRLF & "- Set Interval:          Control+Alt+I" & @CRLF & "- Pause Loop:         Control+Alt+P" & @CRLF & "- Next Wallpaper:   Control+Alt+N   (for in pause mode)"&@CRLF&"- Continue Loop:   Control+Alt+C" & @CRLF & "- Exit Application:  Control+Alt+X" & @CRLF & @CRLF & "Version: " & $version & @CRLF & "Created by broodplank, visit at broodplank.net")

Local $sleep, $pause, $continue

TrayTip("Random Wallpaper Changer", "Random wallpaper loop has been started"& @CRLF &"Press Control+Alt+P to pause loop"& @CRLF &"Press Control+Alt+S to save the current wallpaper", 5, 1)

While 1

	If $sleep = "" Or $sleep = 0 Then $sleep = 5
	$ran = Random(1, 57390, 1)
	InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-" & $ran & ".jpg", @ScriptDir & "/" & $ran & ".jpg")
	ChangeDesktopWallpaper(@ScriptDir & "/" & $ran & ".jpg")
	FileDelete(@ScriptDir & "/" & $ran & ".jpg")
	Sleep($sleep * 1000)

	If $pause = 1 Then
		While 1
			If $continue = 1 Then ExitLoop
			Sleep(20)
		WEnd
	EndIf
WEnd

Func NextWallpaper()
	If $sleep = "" Or $sleep = 0 Then $sleep = 5
	$ran = Random(1, 57390, 1)
	InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-" & $ran & ".jpg", @ScriptDir & "/" & $ran & ".jpg")
	ChangeDesktopWallpaper(@ScriptDir & "/" & $ran & ".jpg")
	FileDelete(@ScriptDir & "/" & $ran & ".jpg")
	Sleep($sleep * 1000)
EndFunc   ;==>NextWallpaper


Func Quit()
	Exit
EndFunc   ;==>Quit

Func PauseLoop()
		TrayTip("Random Wallpaper Changer", "Random wallpaper loop has been paused" & @CRLF & "Press Control+Alt+N to go to the next wallpaper" & @CRLF & "Press Control+Alt+C to continue loop", 5, 1)
		$continue = 0
		$pause = 1
EndFunc   ;==>PauseLoop


Func _ContinueLoop()
	TrayTip("Random Wallpaper Changer", "Random wallpaper loop has been resumed"&@CRLF&"Press Control+Alt+P to repause loop"&@CRLF&"Press Control+Alt+S to save the current wallpaper", 5, 1)
	$continue = 1
	$pause = 0
EndFunc   ;==>_ContinueLoop


Func SetInterval()
	$sleep = InputBox("Random Wallpaper Changer", "Enter the amount of seconds between wallpapers, minimal input is 1", "")
	If $sleep = @error Or $sleep = 0 Then
		Exit
	EndIf
EndFunc   ;==>SetInterval


Func SaveWallpaper()
	InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-" & $ran & ".jpg", @MyDocumentsDir & "/" & $ran & ".jpg")
	ChangeDesktopWallpaper(@MyDocumentsDir & "/" & $ran & ".jpg")
	TrayTip("Random Wallpaper Changer", "Current wallpaper saved, exiting", 1, 0)
	Sleep(1000)
	Exit
EndFunc   ;==>SaveWallpaper

Func ChangeDesktopWallpaper($bmp)
	If Not FileExists($bmp) Then Return -1
	Local $SPI_SETDESKWALLPAPER = 20
	Local $SPIF_UPDATEINIFILE = 1
	Local $SPIF_SENDCHANGE = 2
	Local $REG_DESKTOP = "HKEY_CURRENT_USER\Control Panel\Desktop"
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "WallpaperStyle", "REG_SZ", 4) ; Strech to desktop
	RegWrite($REG_DESKTOP, "Wallpaper", "REG_SZ", $bmp)

	DllCall("user32.dll", "int", "SystemParametersInfo", _
			"int", $SPI_SETDESKWALLPAPER, _
			"int", 0, _
			"str", $bmp, _
			"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))

	Return 0
EndFunc   ;==>ChangeDesktopWallpaper
