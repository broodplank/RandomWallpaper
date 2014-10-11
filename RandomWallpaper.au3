; Random Wallpaper from wallhaven.cc
; Early version

$sleep = InputBox("Random Wallpaper Changer", "Enter the amount of seconds between wallpapers, minimal input is 1", "1")
if $sleep = @error or $sleep = 0 then
	Exit
EndIf


While 1
	$ran = Random(1, 57390, 1)
	InetGet("http://alpha.wallhaven.cc/wallpapers/full/wallhaven-"&$ran&".jpg", @ScriptDir&"/"&$ran&".jpg")
	ChangeDesktopWallpaper(@ScriptDir&"/"&$ran&".jpg")
	FileDelete(@ScriptDir&"/"&$ran&".jpg")
	sleep($sleep * 1000)
WEnd


Func ChangeDesktopWallpaper($bmp)
;===============================================================================
; Usage: _ChangeDesktopWallPaper(@WindowsDir & '\' & 'zapotec.bmp')
; Parameter(s): $bmp - Full Path to BitMap File (*.bmp)
; Requirement(s): None.
; Return Value(s): On Success - Returns 0
; On Failure - -1
;===============================================================================

	If Not FileExists($bmp) Then Return -1
	;The $SPI* values could be defined elsewhere via #include - if you conflict,
	; remove these, or add if Not IsDeclared "SPI_SETDESKWALLPAPER" Logic
	Local $SPI_SETDESKWALLPAPER = 20
	Local $SPIF_UPDATEINIFILE = 1
	Local $SPIF_SENDCHANGE = 2
	Local $REG_DESKTOP= "HKEY_CURRENT_USER\Control Panel\Desktop"

	;Don't tile -  just center
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "WallpaperStyle", "REG_SZ", 4) ; Strech to desktop
	RegWrite($REG_DESKTOP, "Wallpaper", "REG_SZ", $bmp)

	DllCall("user32.dll", "int", "SystemParametersInfo", _
	"int", $SPI_SETDESKWALLPAPER, _
	"int", 0, _
	"str", $bmp, _
	"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))

	Return 0
EndFunc;==>_ChangeDestopWallpaper