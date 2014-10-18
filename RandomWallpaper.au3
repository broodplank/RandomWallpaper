#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=RandomWallpaperChanger.exe
#AutoIt3Wrapper_Res_Description=broodplank.net
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; Random Wallpaper from wallhaven.cc
; Created by broodplank
; Copyright 2014 broodplank.net - All Rights Reserved

;Declare
$version = "1.3"
$wallapers = 70498
Local $sleep, $pause, $continue

;I use my own pause
Opt("TrayAutoPause", 0)

;Configure hotkeys
HotKeySet("^!s", "SaveWallpaper")
HotKeySet("^!p", "PauseLoop")
HotKeySet("^!c", "_ContinueLoop")
HotKeySet("^!n", "NextWallpaper")
HotKeySet("^!i", "SetInterval")
HotKeySet("^!x", "Quit")

;Check if wallhaven.cc is up
Ping("www.wallhaven.cc")
If @error Then
	TrayTip("Random Wallpaper Changer", "There is a connection issue!"&@CRLF&@CRLF&"Possible Reasons:"&@CRLF&"1. You are not connected to the internet"&@CRLF&"2. Wallhaven.cc is down"&@CRLF&"3. Your firewall is blocking this application", 8, 3)
	sleep(5000)
	TrayTip("Random Wallpaper Changer", "Exiting...", 2, 3)
	sleep(1000)
	exit
Endif

;Show hotkeys
MsgBox(0, "Random Wallpaper Changer", "Hotkeys:" & @CRLF & @CRLF & "- Save Wallpaper:   Control+Alt+S" & @CRLF & "- Set Interval:          Control+Alt+I" & @CRLF & "- Pause Loop:         Control+Alt+P" & @CRLF & "- Next Wallpaper:   Control+Alt+N   (for in pause mode)" & @CRLF & "- Continue Loop:   Control+Alt+C" & @CRLF & "- Exit Application:  Control+Alt+X" & @CRLF & @CRLF & "Version: " & $version & @CRLF & "Created by broodplank, visit at broodplank.net")

;Start loop traytip
TrayTip("Random Wallpaper Changer", "Random wallpaper loop has been started" & @CRLF & "Press Control+Alt+P to pause loop" & @CRLF & "Press Control+Alt+S to save the current wallpaper", 5, 1)

;Start loop
While 1

	;make sure sleep is never undeclared
	If $sleep = "" Or $sleep = 0 Then $sleep = 10
	$ran = Random(1, $wallapers, 1)
	InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-" & $ran & ".jpg", @ScriptDir & "/" & $ran & ".jpg")
	ChangeDesktopWallpaper(@ScriptDir & "/" & $ran & ".jpg")
	FileDelete(@ScriptDir & "/" & $ran & ".jpg")
	Sleep($sleep * 1000)

	;Monitor for pause var
	If $pause = 1 Then
		While 1
			If $continue = 1 Then ExitLoop
			Sleep(20)
		WEnd
	EndIf

WEnd

;Manually set next random wallpaper (should be used in pause mode)
Func NextWallpaper()
	If $sleep = "" Or $sleep = 0 Then $sleep = 10
	$ran = Random(1, $wallapers, 1)
	InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-" & $ran & ".jpg", @ScriptDir & "/" & $ran & ".jpg")
	ChangeDesktopWallpaper(@ScriptDir & "/" & $ran & ".jpg")
	FileDelete(@ScriptDir & "/" & $ran & ".jpg")
	Sleep($sleep * 1000)
EndFunc   ;==>NextWallpaper

Func Quit()
	Exit
EndFunc   ;==>Quit

;Function for pausing loop
Func PauseLoop()
	;Check if paused already
	If $pause = 1 Then
		TrayTip("Random Wallpaper Changer", "Already paused" & @CRLF & "Press Control+Alt+C to continue loop", 3, 1)
	Else
		TrayTip("Random Wallpaper Changer", "Random wallpaper loop has been paused" & @CRLF & "Press Control+Alt+N to go to the next wallpaper" & @CRLF & "Press Control+Alt+C to continue loop", 5, 1)
		$continue = 0
		$pause = 1
	EndIf
EndFunc   ;==>PauseLoop


;Function for continuing the loop
Func _ContinueLoop()
	;Check if already looping
	If $continue = 1 Then
		TrayTip("Random Wallpaper Changer", "Already looping" & @CRLF & "Press Control+Alt+P to pause loop", 3, 1)
	Else
		TrayTip("Random Wallpaper Changer", "Random wallpaper loop has been resumed" & @CRLF & "Press Control+Alt+P to repause loop" & @CRLF & "Press Control+Alt+S to save the current wallpaper", 5, 1)
		$continue = 1
		$pause = 0
	EndIf
EndFunc   ;==>_ContinueLoop

;Bring up interval inputbox, default is 10
Func SetInterval()
	$sleep = InputBox("Random Wallpaper Changer", "Enter the amount of seconds between wallpapers, minimal input is 1", "")
	If $sleep = @error Or $sleep = 0 Then
		Exit
	EndIf
EndFunc   ;==>SetInterval

;Download the current wallpaper and set it as background, will be saved in My documents
Func SaveWallpaper()
	;In some rare cases $ran could not be initialized, if so, exit application
	If $ran = "" Then
		MsgBox(16, "Random Wallpaper Changer", "Fatal Error: Random number could not be read. try restarting the application")
		Exit
	Else
		InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-" & $ran & ".jpg", @MyDocumentsDir & "/" & $ran & ".jpg")
		ChangeDesktopWallpaper(@MyDocumentsDir & "/" & $ran & ".jpg")
		TrayTip("Random Wallpaper Changer", "Current wallpaper saved, exiting", 5, 1)
		Sleep(1000)
		Exit
	EndIf
EndFunc   ;==>SaveWallpaper

;UDF for changing wallpaper
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
