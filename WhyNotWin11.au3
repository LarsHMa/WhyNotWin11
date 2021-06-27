#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=.\assets\windows11-logo.ico
#AutoIt3Wrapper_Outfile=WhyNotWin11_x86.exe
#AutoIt3Wrapper_Outfile_x64=WhyNotWin11.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Detection Script to help identify the more niche settings for why your PC isn't Windows 11 ready
#AutoIt3Wrapper_Res_Fileversion=2.2.1.0
#AutoIt3Wrapper_Res_ProductVersion=2.2.1
#AutoIt3Wrapper_Res_LegalCopyright=Robert Maehl, using LGPL 3 License
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
#AutoIt3Wrapper_Res_Icon_Add=includes\freeze_small.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global $sVersion = "2.2.1.0"

#include <File.au3>
#include <Misc.au3>
#include <String.au3>
#include <WinAPISysWin.au3>
#include <EditConstants.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>

#include ".\Includes\_WMIC.au3"

ExtractFiles()
Main()

Func ExtractFiles()
	Select
		Case Not FileExists(@TempDir & "\SupportedProcessorsAMD.txt")
			FileInstall(".\includes\SupportedProcessorsAMD.txt", @TempDir & "\SupportedProcessorsAMD.txt")
			FileInstall(".\includes\SupportedProcessorsIntel.txt", @TempDir & "\SupportedProcessorsIntel.txt")
			FileInstall(".\includes\SupportedProcessorsQualcomm.txt", @TempDir & "\SupportedProcessorsQualcomm.txt")
		Case FileExists(@TempDir & "\SupportedProcessorsAMD.txt")
			If _VersionCompare($sVersion, FileReadLine(@TempDir & "\SupportedProcessorsAMD.txt",1)) = 1 Then
				FileInstall(".\includes\SupportedProcessorsAMD.txt", @TempDir & "\SupportedProcessorsAMD.txt", $FC_OVERWRITE)
				FileInstall(".\includes\SupportedProcessorsIntel.txt", @TempDir & "\SupportedProcessorsIntel.txt", $FC_OVERWRITE)
				FileInstall(".\includes\SupportedProcessorsQualcomm.txt", @TempDir & "\SupportedProcessorsQualcomm.txt", $FC_OVERWRITE)
			EndIf
		Case Else
			;;;
	EndSelect
EndFunc

Func Main()

	$BKC = _WinAPI_GetSysColor($COLOR_WINDOW)

	$hGUI = GUICreate("WhyNotWin11", 800, 600, -1, -1, BitAND($WS_POPUP,$WS_BORDER))
	GUISetBkColor($BKC - 0x070707)
	GUISetFont(8.5,$FW_BOLD,"","Arial")

	GUICtrlSetDefColor(_WinAPI_GetSysColor($COLOR_WINDOWTEXT))
	GUICtrlSetDefBKColor($BKC - 0x070707)

	; Top Most Interaction for Update Text
	$hUpdate = GUICtrlCreateLabel("", 5, 560, 90, 40, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, $BKC - 0x191919)
	GUICtrlSetCursor(-1, 0)

	; Top Most Interaction for Closing Window
	$hExit = GUICtrlCreateLabel("", 760, 10, 30, 30, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 24, $FW_MEDIUM)

	; Allow Dragging of Window
	GUICtrlCreateLabel("", 0, 0, 800, 30, -1, $GUI_WS_EX_PARENTDRAG)

	GUICtrlCreateLabel("", 0, 0, 100, 600)
	GUICtrlSetBkColor(-1, $BKC - 0x191919)

	If @Compiled Then
		;;;
	Else
		GUICtrlCreateIcon(".\includes\Git.ico", -1, 12, 100, 32, 32)
		GUICtrlCreateIcon(".\includes\PP.ico", -1, 56, 100, 32, 32, "", $WS_EX_TRANSPARENT)
		GUICtrlCreateIcon(".\includes\EM.ico", -1, 12, 144, 32, 32)
		GUICtrlCreateIcon(".\includes\Web.ico", -1, 56, 144, 32, 32, "", $WS_EX_TRANSPARENT)
	EndIf

	GUICtrlCreateLabel("Check for Updates", 5, 560, 90, 40, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 8.5, $FW_NORMAL, $GUI_FONTUNDER)
	GUICtrlSetBkColor(-1, $BKC - 0x191919)

	GUICtrlCreateLabel("WhyNotWin11", 10, 10, 80, 20, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, $BKC - 0x191919)
	GUICtrlCreateLabel("v " & $sVersion, 10, 30, 80, 20, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, $BKC - 0x191919)

	GUICtrlCreateLabel("", 100, 560, 700, 40)
	GUICtrlSetBkColor(-1, $BKC - 0x0D0D0D)

	GUICtrlCreateLabel("Your Windows 11 Compatibility Results are Below", 130, 30, 640, 40, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 18, $FW_SEMIBOLD, "", "", $CLEARTYPE_QUALITY)
	GUICtrlCreateLabel("* Results Based on Currently Known Requirements!", 130, 70, 640, 20, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0xE20012)
	GUICtrlSetFont(-1, 10)

	GUICtrlCreateLabel("X", 760, 10, 30, 30, $SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 24, $FW_NORMAL)

	Local $hCheck[11][3]
	Local $hLabel[11] = ["Architecture (CPU + OS)", "Boot Method", "CPU Compatibility", "CPU Core Count", "CPU Frequency", "DirectX + WDDM2", "Disk Partition Type", "RAM Installed", "Secure Boot", "Storage Available", "TPM Version"]

	For $iRow = 0 To 10 Step 1
		$hCheck[$iRow][0] = GUICtrlCreateLabel("?", 130, 110 + $iRow * 40, 40, 40, $SS_CENTER+$SS_SUNKEN+$SS_CENTERIMAGE)
		GUICtrlSetBkColor(-1, 0xE6E6E6)
		$hCheck[$iRow][1] = GUICtrlCreateLabel(" " & $hLabel[$iRow], 170, 110 + $iRow * 40, 300, 40, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 18, $FW_NORMAL)
		$hCheck[$iRow][2] = GUICtrlCreateLabel("Checking...", 470, 110 + $iRow * 40, 300, 40, $SS_CENTER+$SS_SUNKEN+$SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 8.5, $FW_SEMIBOLD)
	Next

	GUISetState(@SW_SHOW, $hGUI)

	$hFile = _TempFile()
	$hDXFile = _TempFile(@TempDir, "dxdiag")
	Run("dxdiag /whql:off /t " & $hDXFile)

	Select
		Case @CPUArch = "X64" And @OSArch = "IA64"
			ContinueCase
		Case @CPUArch = "X64" And @OSArch = "X64"
			GUICtrlSetData($hCheck[0][0], "OK")
			GUICtrlSetBkColor($hCheck[0][0], 0x4CC355)
			GUICtrlSetData($hCheck[0][2], "64 Bit CPU and 64 Bit OS")
		Case @CPUArch = "X64" And @OSArch = "X86"
			GUICtrlSetData($hCheck[0][0], "!")
			GUICtrlSetBkColor($hCheck[0][0], 0xF4C141)
			GUICtrlSetData($hCheck[0][2], "64 Bit CPU, but 32 bit OS")
		Case Else
			GUICtrlSetData($hCheck[0][0], "X")
			GUICtrlSetBkColor($hCheck[0][0], 0xFA113D)
			GUICtrlSetData($hCheck[0][2], "32 Bit CPU and 32 Bit OS")
	EndSelect

	RunWait("powershell -Command $env:firmware_type | Out-File -FilePath " & $hFile, "", @SW_HIDE)
	If Not StringInStr(FileRead($hFile), "Legacy") Then
		GUICtrlSetData($hCheck[1][0], "OK")
		GUICtrlSetBkColor($hCheck[1][0], 0x4CC355)
		GUICtrlSetData($hCheck[1][2], FileReadLine($hFile, 1));"Secure Boot Detected as Enabled")
	Else
		GUICtrlSetData($hCheck[1][0], "X")
		GUICtrlSetBkColor($hCheck[1][0], 0xFA113D)
		GUICtrlSetData($hCheck[1][2], FileReadLine($hFile, 1));"Secure Boot Not Enabled")
	EndIf

	Select
		Case StringInStr(_GetCPUInfo(2), "AMD")
			$iLines = _FileCountLines(@TempDir & "\SupportedProcessorsAMD.txt")
			If @error Then
				GUICtrlSetData($hCheck[2][0], "?")
				GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
			EndIf
			For $iLine = 1 to $iLines Step 1
				$sLine = FileReadLine(@TempDir & "\SupportedProcessorsAMD.txt", $iLine)
				If @error = -1 Or $iLine = $iLines Then
					GUICtrlSetData($hCheck[2][0], "!")
					GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
					ExitLoop
				EndIf
				If StringInStr(_GetCPUInfo(2), $sLine) Then
					GUICtrlSetData($hCheck[2][0], "OK")
					GUICtrlSetBkColor($hCheck[2][0], 0x4CC355)
					ExitLoop
				EndIf
			Next
		Case StringInStr(_GetCPUInfo(2), "Intel")
			$iLines = _FileCountLines(@TempDir & "\SupportedProcessorsIntel.txt")
			If @error Then
				GUICtrlSetData($hCheck[2][0], "?")
				GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
			EndIf
			For $iLine = 1 to $iLines Step 1
				$sLine = FileReadLine(@TempDir & "\SupportedProcessorsIntel.txt", $iLine)
				If @error = -1 Or $iLine = $iLines Then
					GUICtrlSetData($hCheck[2][0], "!")
					GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
					ExitLoop
				EndIf
				If StringInStr(_GetCPUInfo(2), $sLine) Then
					GUICtrlSetData($hCheck[2][0], "OK")
					GUICtrlSetBkColor($hCheck[2][0], 0x4CC355)
					ExitLoop
				EndIf
			Next
		Case StringInStr(_GetCPUInfo(2), "SnapDragon") Or StringInStr(_GetCPUInfo(2), "Microsoft")
			$iLines = _FileCountLines(@TempDir & "\SupportedProcessorsQualcomm.txt")
			If @error Then
				GUICtrlSetData($hCheck[2][0], "?")
				GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
			EndIf
			For $iLine = 1 to $iLines Step 1
				$sLine = FileReadLine(@TempDir & "\SupportedProcessorsQualcomm.txt", $iLine)
				If @error = -1 Or $iLine = $iLines Then
					GUICtrlSetData($hCheck[2][0], "!")
					GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
					ExitLoop
				EndIf
				If StringInStr(_GetCPUInfo(2), $sLine) Then
					GUICtrlSetData($hCheck[2][0], "OK")
					GUICtrlSetBkColor($hCheck[2][0], 0x4CC355)
					ExitLoop
				EndIf
			Next
		Case Else
			GUICtrlSetData($hCheck[2][0], "?")
			GUICtrlSetBkColor($hCheck[2][0], 0xF4C141)
	EndSelect
	GUICtrlSetData($hCheck[2][2], _GetCPUInfo(2))

	If _GetCPUInfo(0) >= 2 Or _GetCPUInfo(1) >= 2 Then
		GUICtrlSetData($hCheck[3][0], "OK")
		GUICtrlSetBkColor($hCheck[3][0], 0x4CC355)
		GUICtrlSetData($hCheck[3][2], _GetCPUInfo(0) & " Cores, " & _GetCPUInfo(1) & " Threads")
	Else
		GUICtrlSetData($hCheck[3][0], "X")
		GUICtrlSetBkColor($hCheck[3][0], 0xFA113D)
		GUICtrlSetData($hCheck[3][2], _GetCPUInfo(0) & " Cores, " & _GetCPUInfo(1) & " Threads")
	EndIf

	If _GetCPUInfo(3) >= 1000 Then
		GUICtrlSetData($hCheck[4][0], "OK")
		GUICtrlSetBkColor($hCheck[4][0], 0x4CC355)
		GUICtrlSetData($hCheck[4][2], _GetCPUInfo(3) & " MHz")
	Else
		GUICtrlSetData($hCheck[4][0], "X")
		GUICtrlSetBkColor($hCheck[4][0], 0xFA113D)
		GUICtrlSetData($hCheck[4][2], _GetCPUInfo(3) & " MHz")
	EndIf

	RunWait("powershell -Command Get-Partition -DriveLetter C | Get-Disk | Select-Object -Property PartitionStyle | Out-File -FilePath " & $hFile, "", @SW_HIDE)
	Select
		Case StringInStr(FileRead($hFile), "Error")
			GUICtrlSetData($hCheck[6][0], "?")
			GUICtrlSetBkColor($hCheck[6][0], 0xF4C141)
			GUICtrlSetData($hCheck[6][2], "Unable to Determine")
		Case StringInStr(FileRead($hFile), "GPT")
			GUICtrlSetData($hCheck[6][0], "OK")
			GUICtrlSetBkColor($hCheck[6][0], 0x4CC355)
			GUICtrlSetData($hCheck[6][2], "GPT Detected")
		Case Else
			GUICtrlSetData($hCheck[6][0], "X")
			GUICtrlSetBkColor($hCheck[6][0], 0xFA113D)
			GUICtrlSetData($hCheck[6][2], "GPT Not Detected")
	EndSelect

	$aMem = DllCall("Kernel32.dll", "int", "GetPhysicallyInstalledSystemMemory", "int*", "")
	If @error Then
		$aMem = "Unknown"
	Else
		$aMem = Round($aMem[1]/1048576, 1)
	EndIf
	If $aMem = 0 Then
		$aMem = MemGetStats()
		$aMem = $aMem[1]
		$aMem = Ceiling($aMem)
	EndIf

	If $aMem >= 4 Then
		GUICtrlSetData($hCheck[7][0], "OK")
		GUICtrlSetBkColor($hCheck[7][0], 0x4CC355)
		GUICtrlSetData($hCheck[7][2], $aMem & " GB")
	Else
		GUICtrlSetData($hCheck[7][0], "X")
		GUICtrlSetBkColor($hCheck[7][0], 0xFA113D)
		GUICtrlSetData($hCheck[7][2], $aMem & " GB")
	EndIf

	RunWait("powershell -Command Confirm-SecureBootUEFI | Out-File -FilePath " & $hFile, "", @SW_HIDE)
	Select
		Case StringInStr(FileRead($hFile), "True")
			GUICtrlSetData($hCheck[8][0], "OK")
			GUICtrlSetBkColor($hCheck[8][0], 0x4CC355)
			GUICtrlSetData($hCheck[8][2], "Enabled")
		Case StringInStr(FileRead($hFile), "False")
			GUICtrlSetData($hCheck[8][0], "OK")
			GUICtrlSetBkColor($hCheck[8][0], 0x4CC355)
			GUICtrlSetData($hCheck[8][2], "Supported")
		Case Else
			GUICtrlSetData($hCheck[8][0], "X")
			GUICtrlSetBkColor($hCheck[8][0], 0xFA113D)
			GUICtrlSetData($hCheck[8][2], "Disabled / Not Detected")
	EndSelect

	If DriveSpaceTotal("C:\")/1024 >= 64 Then
		GUICtrlSetData($hCheck[9][0], "OK")
		GUICtrlSetBkColor($hCheck[9][0], 0x4CC355)
		GUICtrlSetData($hCheck[9][2], Round(DriveSpaceTotal("C:\")/1024, 0) & " GB on C:\")
	Else
		GUICtrlSetData($hCheck[9][0], "X")
		GUICtrlSetBkColor($hCheck[9][0], 0xFA113D)
		GUICtrlSetData($hCheck[9][2], Round(DriveSpaceTotal("C:\")/1024, 0) & " GB on C:\")
	EndIf

	Select
		Case _GetTPMInfo(0) = False
			ContinueCase
		Case _GetTPMInfo(1) = False
			GUICtrlSetData($hCheck[10][0], "X")
			GUICtrlSetBkColor($hCheck[10][0], 0xFA113D)
			GUICtrlSetData($hCheck[10][2], "TPM Missing / Disabled")
		Case Not Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]) >= 1.2
			GUICtrlSetData($hCheck[10][0], "X")
			GUICtrlSetBkColor($hCheck[10][0], 0xFA113D)
			GUICtrlSetData($hCheck[10][2], "TPM " & Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]) & " Not Supported")
		Case _GetTPMInfo(0) = True And _GetTPMInfo(0) = True And Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]) >= 2.0
			GUICtrlSetData($hCheck[10][0], "OK")
			GUICtrlSetBkColor($hCheck[10][0], 0x4CC355)
			GUICtrlSetData($hCheck[10][2], "TPM " & Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]) & " Detected")
		Case _GetTPMInfo(0) = True And _GetTPMInfo(0) = True And Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]) >= 1.2
			;GUICtrlSetData($hCheck[10][0], "OK")
			;GUICtrlSetBkColor($hCheck[10][0], 0xF4C141)
			GUICtrlSetData($hCheck[10][0], "X")
			GUICtrlSetBkColor($hCheck[10][0], 0xFA113D)
			GUICtrlSetData($hCheck[10][2], "TPM " & Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]) & " Detected")
		Case Else
			GUICtrlSetData($hCheck[10][0], "X")
			GUICtrlSetBkColor($hCheck[10][0], 0xFA113D)
			GUICtrlSetData($hCheck[10][2], _GetTPMInfo(0) & " " & _GetTPMInfo(1) & " " & Number(StringSplit(_GetTPMInfo(2), ", ", $STR_NOCOUNT)[0]))
	EndSelect

	FileDelete($hFile)

	While 1
		$hMsg = GUIGetMsg()

		Select

			Case $hMsg = $GUI_EVENT_CLOSE Or $hMsg = $hExit
				GUIDelete($hGUI)
				Exit

			; DirectX 12 takes a while. Grab the result once done
			Case Not ProcessExists("dxdiag.exe") And FileExists($hDXFile)
				Select
					Case StringInStr(FileRead($hDXFile), "DDI Version: 12") And StringInStr(FileRead($hDXFile), "Driver Model: WDDM 3")
						GUICtrlSetData($hCheck[5][0], "OK")
						GUICtrlSetBkColor($hCheck[5][0], 0x4CC355)
						GUICtrlSetData($hCheck[5][2], "DirectX 12, WDDM 3")
					Case StringInStr(FileRead($hDXFile), "DDI Version: 12") And StringInStr(FileRead($hDXFile), "Driver Model: 2") ; SQ1/SQ2
						ContinueCase
					Case StringInStr(FileRead($hDXFile), "DDI Version: 12") And StringInStr(FileRead($hDXFile), "Driver Model: WDDM 2")
						GUICtrlSetData($hCheck[5][0], "OK")
						GUICtrlSetBkColor($hCheck[5][0], 0x4CC355)
						GUICtrlSetData($hCheck[5][2], "DirectX 12, WDDM 2")
					Case Not StringInStr(FileRead($hDXFile), "DDI Version: 12") And StringInStr(FileRead($hDXFile), "Driver Model: WDDM 2")
						GUICtrlSetData($hCheck[5][0], "X")
						GUICtrlSetBkColor($hCheck[5][0], 0xFA113D)
						GUICtrlSetData($hCheck[5][2], "No DirectX 12, but WDDM2")
					Case StringInStr(FileRead($hDXFile), "DDI Version: 12") And Not StringInStr(FileRead($hDXFile), "Driver Model: WDDM 2")
						GUICtrlSetData($hCheck[5][0], "X")
						GUICtrlSetBkColor($hCheck[5][0], 0xFA113D)
						GUICtrlSetData($hCheck[5][2], "DirectX 12, but no WDDM2")
					Case Else
						GUICtrlSetData($hCheck[5][0], "X")
						GUICtrlSetBkColor($hCheck[5][0], 0xFA113D)
						GUICtrlSetData($hCheck[5][2], "No DirectX 12 / WDDM2")
				EndSelect
				FileDelete($hDXFile)

			Case $hMsg = $hUpdate
				Switch _GetLatestRelease($sVersion)
					Case -1
						MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "Test Build?", "You're running a newer build than publically available!", 10)
					Case 0
						Switch @error
							Case 0
								MsgBox($MB_OK+$MB_ICONINFORMATION+$MB_TOPMOST, "Up to Date", "You're running the latest build!", 10)
							Case 1
								MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "Unable to Check for Updates", "Unable to load release data.", 10)
							Case 2
								MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "Unable to Check for Updates", "Invalid Data Received!", 10)
							Case 3
								Switch @extended
									Case 0
										MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "Unable to Check for Updates", "Invalid Release Tags Received!", 10)
									Case 1
										MsgBox($MB_OK+$MB_ICONWARNING+$MB_TOPMOST, "Unable to Check for Updates", "Invalid Release Types Received!", 10)
								EndSwitch
						EndSwitch
					Case 1
						If MsgBox($MB_YESNO+$MB_ICONINFORMATION+$MB_TOPMOST, "Update Available", "An Update is Availabe, would you like to download it?", 10) = $IDYES Then ShellExecute("https://fcofix.org/WhyNotWin11/releases")
				EndSwitch

			Case Else
				;;;

		EndSelect
	WEnd
EndFunc

Func _GetLatestRelease($sCurrent)

	Local $dAPIBin
	Local $sAPIJSON

	$dAPIBin = InetRead("https://api.fcofix.org/repos/rcmaehl/WhyNotWin11/releases")
	If @error Then Return SetError(1, 0, 0)
	$sAPIJSON = BinaryToString($dAPIBin)
	If @error Then Return SetError(2, 0, 0)

	Local $aReleases = _StringBetween($sAPIJSON, '"tag_name":"', '",')
	If @error Then Return SetError(3, 0, 0)
	Local $aRelTypes = _StringBetween($sAPIJSON, '"prerelease":', ',')
	If @error Then Return SetError(3, 1, 0)
	Local $aCombined[UBound($aReleases)][2]

	For $iLoop = 0 To UBound($aReleases) - 1 Step 1
		$aCombined[$iLoop][0] = $aReleases[$iLoop]
		$aCombined[$iLoop][1] = $aRelTypes[$iLoop]
	Next

	Return _VersionCompare($aCombined[0][0], $sCurrent)

EndFunc
