#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=UniSmart_Launcher.ico
#AutoIt3Wrapper_Outfile=UniSmart_Launcher.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniSmart Launcher for SSE
#AutoIt3Wrapper_Res_Fileversion=1.2.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.2.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2016-2019, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_SaveSource=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ;**** Pragma Compile ****
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Compression, 9)
#pragma compile(Compatibility, vista, win7, win8, win81)
#pragma compile(InputBoxRes, true)
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(FileDescription, 'UniSmart Launcher for SSE')
#pragma compile(FileVersion, 1.2.0.47)
#pragma compile(InternalName, 'UniSmart Launcher for SSE')
#pragma compile(LegalCopyright, '2016-2019, SalFisher47')
#pragma compile(OriginalFilename, UniSmart_Launcher.exe)
#pragma compile(ProductName, 'UniSmart Launcher for SSE')
#pragma compile(ProductVersion, 1.2.0.47)
#EndRegion ;**** Pragma Compile ****

; === UniSmart_Launcher.au3 ========================================================================================================
; Title .........: UniSmart Launcher for SSE
; Version .......: 1.2.0.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: UniSmart Launcher for SSE
; Author(s) .....: SalFisher47
; Last Modified .: March 21, 2019
; ==================================================================================================================================

#include <File.au3>

Global $Env_RoamingAppData = @AppDataDir, _
		$Env_LocalAppData = @LocalAppDataDir, _
		$Env_ProgramData = @AppDataCommonDir, _
		$Env_UserProfile = @UserProfileDir, _
		$Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
		If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"
$launcherIni = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"

$launcherIni_AppName = IniRead($launcherIni, "Loader", "appName", "")
$launcherIni_AppID = IniRead($launcherIni, "Loader", "appID", "")

$launcherIni_GameExe = IniRead($launcherIni, "Loader", "gameExe", "")
Switch StringLeft($launcherIni_GameExe, 2)
	Case ".."
		$gameExe_Path_full = _PathFull(@ScriptDir & "\" & $launcherIni_GameExe)
	Case "\."
		$gameExe_Path_full = _PathFull(@ScriptDir & $launcherIni_GameExe)
	Case ".\"
		$gameExe_Path_full = @ScriptDir & "\" & StringTrimLeft($launcherIni_GameExe, 2)
	Case Else
		$gameExe_Path_full = @ScriptDir & "\" & $launcherIni_GameExe
EndSwitch
$gameExe_Only = StringTrimLeft($gameExe_Path_full, StringInStr($gameExe_Path_full, "\", 0, -1))
$gameExe_Path_Only = StringTrimRight($gameExe_Path_full, StringLen($gameExe_Only)+1)

$launcherIni_GameDll = IniRead($launcherIni, "Loader", "gameDll", "")
Switch StringLeft($launcherIni_GameDll, 2)
	Case ".."
		$gameDll_Path_full = _PathFull(@ScriptDir & "\" & $launcherIni_GameDll)
	Case "\."
		$gameDll_Path_full = _PathFull(@ScriptDir & $launcherIni_GameDll)
	Case ".\"
		$gameDll_Path_full = @ScriptDir & "\" & StringTrimLeft($launcherIni_GameDll, 2)
	Case Else
		$gameDll_Path_full = @ScriptDir & "\" & $launcherIni_GameDll
EndSwitch
$gameDll_Only = StringTrimLeft($gameDll_Path_full, StringInStr($gameDll_Path_full, "\", 0, -1))
$gameDll_Path_Only = StringTrimRight($gameDll_Path_full, StringLen($gameDll_Only)+1)

$launcherIni_GameCompat = IniRead($launcherIni, "Loader", "gameCompat", "")
$launcherIni_LoaderCompat = IniRead($launcherIni, "Loader", "loaderCompat", "")
$launcherIni_EmuMethod = IniRead($launcherIni, "Loader", "emuMethod", "")

$launcherIni_Stats_Copy = IniRead($launcherIni, "Stats", "stats_copy", "1")
$launcherIni_Stats_Check = IniRead($launcherIni, "Stats", "stats_check", "5")
$launcherIni_Stats_dir = IniRead($launcherIni, "Stats", "stats_dir", "SmartSteamEmu_0")
$launcherIni_Save_dir = IniRead($launcherIni, "Stats", "savegame_dir", $launcherIni_Stats_dir)
$launcherIni_Save_subdir = IniRead($launcherIni, "Stats", "savegame_subdir", "")
$launcherIni_Gamedir_Path_Rel = IniRead($launcherIni, "Stats", "gamedir_path", "")

$gameDir_Path_full = StringTrimRight(_PathFull(@ScriptDir & "\" & $launcherIni_Gamedir_Path_Rel), 1)
$sseDir_Path_full = $gameDll_Path_Only & "\SmartSteamEmu"

$gameExe_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $gameExe_Path_full)
$gameExe_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $gameExe_Path_full)

$gameDll_o32_Only = "steam_api.dll"
$gameDll_o32_Path_full = $gameDll_Path_Only & "\" & $gameDll_o32_Only
$gameDll_o32_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $gameDll_o32_Path_full)
$gameDll_o32_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $gameDll_o32_Path_full)
$gameDll_o64_Only = "steam_api64.dll"
$gameDll_o64_Path_full = $gameDll_Path_Only & "\" & $gameDll_o64_Only
$gameDll_o64_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $gameDll_o64_Path_full)
$gameDll_o64_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $gameDll_o64_Path_full)

$loaderExe_Only = "SmartSteamLoader.exe"
$loaderExe_Path_full = $gameDll_Path_Only & "\" & $loaderExe_Only
$loaderExe_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $loaderExe_Path_full)
$loaderExe_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $loaderExe_Path_full)
$loaderExe_Path_Rel_2_launcherIni = _PathGetRelative(@ScriptDir, $loaderExe_Path_full)

$loaderIni_Only = "SmartSteamEmu.ini"
$loaderIni_Path_full = $gameDll_Path_Only & "\" & $loaderIni_Only
$loaderIni_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $loaderIni_Path_full)
$loaderIni_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $loaderIni_Path_full)
$loaderIni_Path_Rel_2_launcherIni = _PathGetRelative(@ScriptDir, $loaderIni_Path_full)

$loaderDll_s32_Only = "SmartSteamEmu.dll"
$loaderDll_s32_Path_full = $gameDll_Path_Only & "\" & $loaderDll_s32_Only
$loaderDll_s32_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $loaderDll_s32_Path_full)
$loaderDll_s32_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $loaderDll_s32_Path_full)
$loaderDll_s64_Only = "SmartSteamEmu64.dll"
$loaderDll_s64_Path_full = $gameDll_Path_Only & "\" & $loaderDll_s64_Only
$loaderDll_s64_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $loaderDll_s64_Path_full)
$loaderDll_s64_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $loaderDll_s64_Path_full)

$gameDll_v32_Only = "ValveApi.dll"
$gameDll_v32_Path_full = $gameDll_Path_Only & "\" & $gameDll_v32_Only
$gameDll_v32_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $gameDll_v32_Path_full)
$gameDll_v32_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $gameDll_v32_Path_full)
$gameDll_v64_Only = "ValveApi64.dll"
$gameDll_v64_Path_full = $gameDll_Path_Only & "\" & $gameDll_v64_Only
$gameDll_v64_Path_Rel_2_gameDir = _PathGetRelative($gameDir_Path_full, $gameDll_v64_Path_full)
$gameDll_v64_Path_Rel_2_sseIni = _PathGetRelative($gameDll_Path_Only, $gameDll_v64_Path_full)

$loaderIni_StorageOnAppdata = IniRead($loaderIni_Path_full, "SmartSteamEmu", "StorageOnAppdata", 0)
$loaderIni_RemoteStoragePath = IniRead($loaderIni_Path_full, "SmartSteamEmu", "RemoteStoragePath", "")

Switch $launcherIni_Stats_dir
	Case "SmartSteamEmu_0"
		$loaderIni_StorageOnAppdata = 0
	Case "SmartSteamEmu_1"
		$loaderIni_StorageOnAppdata = 1
	Case ""
		$loaderIni_StorageOnAppdata = 0
		IniWrite($launcherIni, "Stats", "stats_dir", " SmartSteamEmu_0")
	Case Else
		$loaderIni_StorageOnAppdata = 0
		IniWrite($launcherIni, "Stats", "stats_dir", " SmartSteamEmu_0")
EndSwitch

Switch $launcherIni_Save_dir
	Case "MyDocs"
		$Savegame_dir = @MyDocumentsDir & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "PublicDocs"
		$Savegame_dir = @DocumentsCommonDir & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "RoamingAppData"
		$Savegame_dir = $Env_RoamingAppData & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "LocalAppData"
		$Savegame_dir = $Env_LocalAppData & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "ProgramData"
		$Savegame_dir = $Env_ProgramData & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "SavedGames"
		$Savegame_dir = $Env_SavedGames & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "SmartSteamEmu_0"
		Switch $loaderIni_StorageOnAppdata
			Case 0
				$Savegame_dir = $sseDir_Path_full & "\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
			Case 1
				$Savegame_dir = $Env_RoamingAppData & "\SmartSteamEmu\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
				IniWrite($launcherIni, "Stats", "savegame_dir", " SmartSteamEmu_1")
		EndSwitch
	Case "SmartSteamEmu_1"
		Switch $loaderIni_StorageOnAppdata
			Case 1
				$Savegame_dir = $Env_RoamingAppData & "\SmartSteamEmu\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
			Case 0
				$Savegame_dir = $sseDir_Path_full & "\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
				IniWrite($launcherIni, "Stats", "savegame_dir", " SmartSteamEmu_0")
		EndSwitch
	Case "UserProfile"
		$Savegame_dir = @UserProfileDir & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = $Savegame_dir
	Case "GameDir"
		$Savegame_dir = $gameDir_Path_full & "\" & $launcherIni_Save_subdir
		$loaderIni_RemoteStoragePath = _PathFull(_PathGetRelative($gameDll_Path_Only, $Savegame_dir), $gameDll_Path_Only)
	Case ""
		Switch $loaderIni_StorageOnAppdata
			Case 0
				$Savegame_dir = $sseDir_Path_full & "\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
				IniWrite($launcherIni, "Stats", "savegame_dir", " SmartSteamEmu_0")
			Case 1
				$Savegame_dir = $Env_RoamingAppData & "\SmartSteamEmu\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
				IniWrite($launcherIni, "Stats", "savegame_dir", " SmartSteamEmu_1")
		EndSwitch
	Case Else
		Switch $loaderIni_StorageOnAppdata
			Case 0
				$Savegame_dir = $sseDir_Path_full & "\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
				IniWrite($launcherIni, "Stats", "savegame_dir", " SmartSteamEmu_0")
			Case 1
				$Savegame_dir = $Env_RoamingAppData & "\SmartSteamEmu\" & $launcherIni_AppID & "\remote"
				$loaderIni_RemoteStoragePath = ""
				IniWrite($launcherIni, "Stats", "savegame_dir", " SmartSteamEmu_1")
		EndSwitch
EndSwitch

Switch $loaderIni_StorageOnAppdata
	Case 0
		$Stats_dir = $sseDir_Path_full & "\" & $launcherIni_AppID
		$SteamId_file = $sseDir_Path_full & "\steam_id.ini"
	Case 1
		$Stats_dir = $Env_RoamingAppData & "\SmartSteamEmu\" & $launcherIni_AppID
		$SteamId_file = $Env_RoamingAppData & "\SmartSteamEmu\steam_id.ini"
EndSwitch

$launcherIni_GameCmd = IniRead($launcherIni, "Loader", "gameCmd", "")
If $CmdLineRaw <> "" Then
	$launcherIni_GameCmd = $CmdLineRaw & " " & IniRead($launcherIni, "Loader", "gameCmd", "")
EndIf
$launcherIni_Language = IniRead($launcherIni, "Loader", "language", "")
If $launcherIni_Language == "" Then
	;IniWrite($launcherIni, "Loader", "language", " english")
	$launcherIni_Language = "english"
EndIf
$launcherIni_PlayerName = IniRead($launcherIni, "Loader", "playerName", "")
If $launcherIni_PlayerName == "" Then
	;IniWrite($launcherIni, "Loader", "playerName", " " & @UserName)
	$launcherIni_PlayerName = @UserName
EndIf

$steam_LanguageS = ""
$steam_LanguageS = RegRead("HKCU\Software\Valve\Source", "Language")
If $steam_LanguageS == "" Then $steam_LanguageS = "english"
$steam_Language = ""
$steam_Language = RegRead("HKCU\Software\Valve\Steam", "Language")
If $steam_Language == "" Then $steam_Language = "english"
$steam_Username = ""
$steam_Username = RegRead("HKCU\Software\Valve\Steam", "LastGameNameUsed")
If $steam_Username == "" Then $steam_Username = @UserName
$steam_SteamClientDll = ""
$steam_SteamClientDll = RegRead("HKCU\Software\Valve\Steam\ActiveProcess", "SteamClientDll")
$steam_SteamClientDll64 = ""
$steam_SteamClientDll64 = RegRead("HKCU\Software\Valve\Steam\ActiveProcess", "SteamClientDll64")

If Not FileExists($loaderIni_Path_full) Then
	If $launcherIni_AppName <> "" Then
		MsgBox(16, $launcherIni_AppName & " Launcher", "File not found:" & @CRLF & $loaderIni_Path_Rel_2_launcherIni)
		Exit
	Else
		MsgBox(16, "sseLauncher", "File not found:" & @CRLF & $loaderIni_Path_Rel_2_launcherIni)
		Exit
	EndIf
Else
	If IniRead($loaderIni_Path_full, "Launcher", "Target", "") <> $gameExe_Path_Rel_2_sseIni Then IniWrite($loaderIni_Path_full, "Launcher", "Target", " " & $gameExe_Path_Rel_2_sseIni)
	If IniRead($loaderIni_Path_full, "Launcher", "StartIn", "") <> "" Then IniWrite($loaderIni_Path_full, "Launcher", "StartIn", "")
	If IniRead($loaderIni_Path_full, "Launcher", "SteamClientPath", "") <> $loaderDll_s32_Path_Rel_2_sseIni Then IniWrite($loaderIni_Path_full, "Launcher", "SteamClientPath", " " & $loaderDll_s32_Path_Rel_2_sseIni)
	If IniRead($loaderIni_Path_full, "Launcher", "SteamClientPath64", "") <> $loaderDll_s64_Path_Rel_2_sseIni Then IniWrite($loaderIni_Path_full, "Launcher", "SteamClientPath", " " & $loaderDll_s64_Path_Rel_2_sseIni)
	If IniRead($loaderIni_Path_full, "Launcher", "CommandLine", "") <> $launcherIni_GameCmd Then IniWrite($loaderIni_Path_full, "Launcher", "CommandLine", " " & $launcherIni_GameCmd)
	If IniRead($loaderIni_Path_full, "SmartSteamEmu", "StorageOnAppdata", "") <> StringRight($loaderIni_StorageOnAppdata, 1) Then IniWrite($loaderIni_Path_full, "SmartSteamEmu", "StorageOnAppdata", $loaderIni_StorageOnAppdata)
	If IniRead($loaderIni_Path_full, "SmartSteamEmu", "RemoteStoragePath", "") <> $loaderIni_RemoteStoragePath Then IniWrite($loaderIni_Path_full, "SmartSteamEmu", "RemoteStoragePath", " " & $loaderIni_RemoteStoragePath)
	If IniRead($loaderIni_Path_full, "SteamApi", "OriginalSteamApi", "") <> $gameDll_v32_Path_Rel_2_sseIni Then IniWrite($loaderIni_Path_full, "SteamApi", "OriginalSteamApi", " " & $gameDll_v32_Path_Rel_2_sseIni)
	If IniRead($loaderIni_Path_full, "SteamApi", "OriginalSteamApi64", "") <> $gameDll_v64_Path_Rel_2_sseIni Then IniWrite($loaderIni_Path_full, "SteamApi", "OriginalSteamApi64", " " & $gameDll_v64_Path_Rel_2_sseIni)
	If $launcherIni_PlayerName == @UserName Then $launcherIni_PlayerName = "AccountName"
	If IniRead($loaderIni_Path_full, "SmartSteamEmu", "PersonaName", "") <> $launcherIni_PlayerName Then IniWrite($loaderIni_Path_full, "SmartSteamEmu", "PersonaName", " " & $launcherIni_PlayerName)
	If IniRead($loaderIni_Path_full, "SmartSteamEmu", "AppID", "") <> $launcherIni_AppID Then IniWrite($loaderIni_Path_full, "SmartSteamEmu", "AppID", " " & $launcherIni_AppID)
	If IniRead($loaderIni_Path_full, "SmartSteamEmu", "Language", "") <> $launcherIni_Language Then IniWrite($loaderIni_Path_full, "SmartSteamEmu", "Language", " " & $launcherIni_Language)
EndIf
If Not FileExists($loaderExe_Path_full) Then
	If $launcherIni_AppName <> "" Then
		MsgBox(16, $launcherIni_AppName & " Launcher", "File not found:" & @CRLF & $loaderExe_Path_Rel_2_launcherIni)
		Exit
	Else
		MsgBox(16, "sseLauncher", "File not found:" & @CRLF & $loaderExe_Path_Rel_2_launcherIni)
		Exit
	EndIf
Else
	If RegRead("HKCU\Software\Valve\Source", "Language") <> $launcherIni_Language Then RegWrite("HKCU\Software\Valve\Source", "Language", "REG_SZ", $launcherIni_Language)
	If RegRead("HKCU\Software\Valve\Steam", "Language") <> $launcherIni_Language Then RegWrite("HKCU\Software\Valve\Steam", "Language", "REG_SZ", $launcherIni_Language)
	If $launcherIni_LoaderCompat <> "" Then RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $loaderExe_Path_full, "REG_SZ", $launcherIni_LoaderCompat)
	If $launcherIni_GameCompat <> "" Then RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $gameExe_Path_full, "REG_SZ", $launcherIni_GameCompat)
	If $launcherIni_AppName <> "" Then
		;If Not FileExists(@ScriptDir & "\" & StringTrimRight($launcherIni_LoaderExe, StringLen($launcherIni_LoaderExe_Only)) & "SmartSteamEmu\Plugins\SSEOverlay.ini") Then
		;	$SSEOverlayIni = FileOpen(@ScriptDir & "\" & StringTrimRight($launcherIni_LoaderExe, StringLen($launcherIni_LoaderExe_Only)) & "SmartSteamEmu\Plugins\SSEOverlay.ini", 10)
		;	FileClose($SSEOverlayIni)
		;EndIf
		If IniRead($gameDll_Path_Only & "\SmartSteamEmu\Plugins\SSEOverlay.ini", "AppIdMap", $launcherIni_AppID, "") <> $launcherIni_AppName Then
			IniWrite($gameDll_Path_Only & "\SmartSteamEmu\Plugins\SSEOverlay.ini", "AppIdMap", $launcherIni_AppID, $launcherIni_AppName)
		EndIf
		FileCopy($Savegame_dir & "\_sse\steam_id.ini", $SteamId_file, 9)
		If FileExists(@ScriptDir & "\SmartsteamEmu.log") And FileRead(@ScriptDir & "\SmartsteamEmu.log") <> "" Then FileClose(FileOpen(@ScriptDir & "\SmartsteamEmu.log", 2))
	EndIf
	Switch $launcherIni_EmuMethod
		Case 1
			If (FileExists($loaderDll_s32_Path_full)) Or (FileExists($loaderDll_s64_Path_full)) Then
				If $launcherIni_Stats_Copy == 1 Then
					If FileExists($Savegame_dir & "\_sse\stats_ex.bin") Then
						$stats_ex_sse = FileOpen($Savegame_dir & "\_sse\stats_ex.bin", 0)
						$stats_ex_sse_date = FileReadLine($stats_ex_sse, 1)
						FileClose($stats_ex_sse)
						$stats_ex_bin = FileOpen($Stats_dir & "\stats_ex.bin", 0)
						$stats_ex_bin_date = FileReadLine($stats_ex_bin, 1)
						FileClose($stats_ex_bin)
						If $stats_ex_sse_date <> $stats_ex_bin_date Then
							FileCopy($Savegame_dir & "\_sse\stats.bin", $Stats_dir & "\stats.bin", 9)
							FileCopy($Savegame_dir & "\_sse\stats_ex.bin", $Stats_dir & "\stats_ex.bin", 9)
						EndIf
					EndIf

					ShellExecute($loaderExe_Path_full, "", $gameDll_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					Sleep(60000)
					While ProcessExists($gameExe_Only)
						If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
							FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
							$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
							FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
							FileClose($stats_ex)
							FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
						EndIf
						Sleep(Number($launcherIni_Stats_Check) * 60000)
					WEnd
					If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
						FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
						$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
						FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
						FileClose($stats_ex)
						FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
					EndIf
					FileDelete($Stats_dir & "\stats.bin")
					FileDelete($Stats_dir & "\stats_ex.bin")
				Else
					ShellExecute($loaderExe_Path_full, "", $gameDll_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					;Sleep(60000)
				EndIf
			ElseIf (FileExists($gameDll_v32_Path_full)) Or (FileExists($gameDll_v64_Path_full)) Then
				FileMove($gameDll_o32_Path_full, $loaderDll_s32_Path_full, 0)
				FileMove($gameDll_o64_Path_full, $loaderDll_s64_Path_full, 0)
				FileMove($gameDll_v32_Path_full, $gameDll_o32_Path_full, 0)
				FileMove($gameDll_v64_Path_full, $gameDll_o64_Path_full, 0)
				If $launcherIni_Stats_Copy == 1 Then
					If FileExists($Savegame_dir & "\_sse\stats_ex.bin") Then
						$stats_ex_sse = FileOpen($Savegame_dir & "\_sse\stats_ex.bin", 0)
						$stats_ex_sse_date = FileReadLine($stats_ex_sse, 1)
						FileClose($stats_ex_sse)
						$stats_ex_bin = FileOpen($Stats_dir & "\stats_ex.bin", 0)
						$stats_ex_bin_date = FileReadLine($stats_ex_bin, 1)
						FileClose($stats_ex_bin)
						If $stats_ex_sse_date <> $stats_ex_bin_date Then
							FileCopy($Savegame_dir & "\_sse\stats.bin", $Stats_dir & "\stats.bin", 9)
							FileCopy($Savegame_dir & "\_sse\stats_ex.bin", $Stats_dir & "\stats_ex.bin", 9)
						EndIf
					EndIf

					ShellExecute($loaderExe_Path_full, "", $gameDll_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					Sleep(60000)
					While ProcessExists($gameExe_Only)
						If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
							FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
							$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
							FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
							FileClose($stats_ex)
							FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
						EndIf
						Sleep(Number($launcherIni_Stats_Check) * 60000)
					WEnd
					If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
						FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
						$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
						FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
						FileClose($stats_ex)
						FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
					EndIf
					FileDelete($Stats_dir & "\stats.bin")
					FileDelete($Stats_dir & "\stats_ex.bin")
				Else
					ShellExecute($loaderExe_Path_full, "", $gameDll_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					;Sleep(60000)
				EndIf
			EndIf
		Case 2
			If (FileExists($gameDll_v32_Path_full)) Or (FileExists($gameDll_v64_Path_full)) Then
				If $launcherIni_Stats_Copy == 1 Then
					If FileExists($Savegame_dir & "\_sse\stats_ex.bin") Then
						$stats_ex_sse = FileOpen($Savegame_dir & "\_sse\stats_ex.bin", 0)
						$stats_ex_sse_date = FileReadLine($stats_ex_sse, 1)
						FileClose($stats_ex_sse)
						$stats_ex_bin = FileOpen($Stats_dir & "\stats_ex.bin", 0)
						$stats_ex_bin_date = FileReadLine($stats_ex_bin, 1)
						FileClose($stats_ex_bin)
						If $stats_ex_sse_date <> $stats_ex_bin_date Then
							FileCopy($Savegame_dir & "\_sse\stats.bin", $Stats_dir & "\stats.bin", 9)
							FileCopy($Savegame_dir & "\_sse\stats_ex.bin", $Stats_dir & "\stats_ex.bin", 9)
						EndIf
					EndIf

					ShellExecute($gameExe_Path_full, $launcherIni_GameCmd, $gameExe_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					Sleep(60000)
					While ProcessExists($gameExe_Only)
						If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
							FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
							$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
							FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
							FileClose($stats_ex)
							FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
						EndIf
						Sleep(Number($launcherIni_Stats_Check) * 60000)
					WEnd
					If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
						FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
						$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
						FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
						FileClose($stats_ex)
						FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
					EndIf
					FileDelete($Stats_dir & "\stats.bin")
					FileDelete($Stats_dir & "\stats_ex.bin")
				Else
					ShellExecute($gameExe_Path_full, $launcherIni_GameCmd, $gameExe_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					;Sleep(60000)
				EndIf
			ElseIf (FileExists($loaderDll_s32_Path_full)) Or (FileExists($loaderDll_s64_Path_full)) Then
				FileMove($gameDll_o32_Path_full, $gameDll_v32_Path_full, 0)
				FileMove($gameDll_o64_Path_full, $gameDll_v64_Path_full, 0)
				FileMove($loaderDll_s32_Path_full, $gameDll_o32_Path_full, 0)
				FileMove($loaderDll_s64_Path_full, $gameDll_o64_Path_full, 0)
				If $launcherIni_Stats_Copy == 1 Then
					If FileExists($Savegame_dir & "\_sse\stats_ex.bin") Then
						$stats_ex_sse = FileOpen($Savegame_dir & "\_sse\stats_ex.bin", 0)
						$stats_ex_sse_date = FileReadLine($stats_ex_sse, 1)
						FileClose($stats_ex_sse)
						$stats_ex_bin = FileOpen($Stats_dir & "\stats_ex.bin", 0)
						$stats_ex_bin_date = FileReadLine($stats_ex_bin, 1)
						FileClose($stats_ex_bin)
						If $stats_ex_sse_date <> $stats_ex_bin_date Then
							FileCopy($Savegame_dir & "\_sse\stats.bin", $Stats_dir & "\stats.bin", 9)
							FileCopy($Savegame_dir & "\_sse\stats_ex.bin", $Stats_dir & "\stats_ex.bin", 9)
						EndIf
					EndIf

					ShellExecute($gameExe_Path_full, $launcherIni_GameCmd, $gameExe_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					Sleep(60000)
					While ProcessExists($gameExe_Only)
						If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
							FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
							$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
							FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
							FileClose($stats_ex)
							FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
						EndIf
						Sleep(Number($launcherIni_Stats_Check) * 60000)
					WEnd
					If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
						FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
						$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
						FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
						FileClose($stats_ex)
						FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
					EndIf
					FileDelete($Stats_dir & "\stats.bin")
					FileDelete($Stats_dir & "\stats_ex.bin")
				Else
					ShellExecute($gameExe_Path_full, $launcherIni_GameCmd, $gameExe_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					;Sleep(60000)
				EndIf
			EndIf
		Case Else
			If (FileExists($loaderDll_s32_Path_full)) Or (FileExists($loaderDll_s64_Path_full)) Then
				IniWrite($launcherIni, "Loader", "emuMethod", " 1")
				If $launcherIni_Stats_Copy == 1 Then
					If FileExists($Savegame_dir & "\_sse\stats_ex.bin") Then
						$stats_ex_sse = FileOpen($Savegame_dir & "\_sse\stats_ex.bin", 0)
						$stats_ex_sse_date = FileReadLine($stats_ex_sse, 1)
						FileClose($stats_ex_sse)
						$stats_ex_bin = FileOpen($Stats_dir & "\stats_ex.bin", 0)
						$stats_ex_bin_date = FileReadLine($stats_ex_bin, 1)
						FileClose($stats_ex_bin)
						If $stats_ex_sse_date <> $stats_ex_bin_date Then
							FileCopy($Savegame_dir & "\_sse\stats.bin", $Stats_dir & "\stats.bin", 9)
							FileCopy($Savegame_dir & "\_sse\stats_ex.bin", $Stats_dir & "\stats_ex.bin", 9)
						EndIf
					EndIf

					ShellExecute($loaderExe_Path_full, "", $gameDll_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					Sleep(60000)
					While ProcessExists($gameExe_Only)
						If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
							FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
							$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
							FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
							FileClose($stats_ex)
							FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
						EndIf
						Sleep(Number($launcherIni_Stats_Check) * 60000)
					WEnd
					If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
						FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
						$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
						FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
						FileClose($stats_ex)
						FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
					EndIf
					FileDelete($Stats_dir & "\stats.bin")
					FileDelete($Stats_dir & "\stats_ex.bin")
				Else
					ShellExecute($loaderExe_Path_full, "", $gameDll_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					;Sleep(60000)
				EndIf
			ElseIf (FileExists($gameDll_v32_Path_full)) Or (FileExists($gameDll_v64_Path_full)) Then
				IniWrite($launcherIni, "Loader", "emuMethod", " 2")
				If $launcherIni_Stats_Copy == 1 Then
					If FileExists($Savegame_dir & "\_sse\stats_ex.bin") Then
						$stats_ex_sse = FileOpen($Savegame_dir & "\_sse\stats_ex.bin", 0)
						$stats_ex_sse_date = FileReadLine($stats_ex_sse, 1)
						FileClose($stats_ex_sse)
						$stats_ex_bin = FileOpen($Stats_dir & "\stats_ex.bin", 0)
						$stats_ex_bin_date = FileReadLine($stats_ex_bin, 1)
						FileClose($stats_ex_bin)
						If $stats_ex_sse_date <> $stats_ex_bin_date Then
							FileCopy($Savegame_dir & "\_sse\stats.bin", $Stats_dir & "\stats.bin", 9)
							FileCopy($Savegame_dir & "\_sse\stats_ex.bin", $Stats_dir & "\stats_ex.bin", 9)
						EndIf
					EndIf

					ShellExecute($gameExe_Path_full, $launcherIni_GameCmd, $gameExe_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					Sleep(60000)
					While ProcessExists($gameExe_Only)
						If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
							FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
							$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
							FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
							FileClose($stats_ex)
							FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
						EndIf
						Sleep(Number($launcherIni_Stats_Check) * 60000)
					WEnd
					If Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0) > Number(FileGetTime($Savegame_dir & "\_sse\stats.bin", 0, 1), 0) Then
						FileCopy($Stats_dir & "\stats.bin", $Savegame_dir & "\_sse\stats.bin", 9)
						$stats_ex = FileOpen($Stats_dir & "\stats_ex.bin", 2)
						FileWriteLine($stats_ex, Number(FileGetTime($Stats_dir & "\stats.bin", 0, 1), 0))
						FileClose($stats_ex)
						FileCopy($Stats_dir & "\stats_ex.bin", $Savegame_dir & "\_sse\stats_ex.bin", 9)
					EndIf
					FileDelete($Stats_dir & "\stats.bin")
					FileDelete($Stats_dir & "\stats_ex.bin")
				Else
					ShellExecute($gameExe_Path_full, $launcherIni_GameCmd, $gameExe_Path_Only)
					ProcessWait($gameExe_Only)
					If Not FileExists($Savegame_dir & "\_sse\steam_id.ini") Then FileCopy($SteamId_file, $Savegame_dir & "\_sse\steam_id.ini", 8)
					;Sleep(60000)
				EndIf
			EndIf
	EndSwitch
	If RegRead("HKCU\Software\Valve\Source", "Language") <> $steam_LanguageS Then RegWrite("HKCU\Software\Valve\Source", "Language", "REG_SZ", $steam_LanguageS)
	If RegRead("HKCU\Software\Valve\Steam", "Language") <> $steam_Language Then RegWrite("HKCU\Software\Valve\Steam", "Language", "REG_SZ", $steam_Language)
	If RegRead("HKCU\Software\Valve\Steam", "LastGameNameUsed") <> $steam_Username Then RegWrite("HKCU\Software\Valve\Steam", "LastGameNameUsed", "REG_SZ", $steam_Username)
	If RegRead("HKCU\Software\Valve\Steam\ActiveProcess", "SteamClientDll") <> $steam_SteamClientDll Then RegWrite("HKCU\Software\Valve\Steam\ActiveProcess", "SteamClientDll", "REG_SZ", $steam_SteamClientDll)
	If RegRead("HKCU\Software\Valve\Steam\ActiveProcess", "SteamClientDll64") <> $steam_SteamClientDll64 Then RegWrite("HKCU\Software\Valve\Steam\ActiveProcess", "SteamClientDll64", "REG_SZ", $steam_SteamClientDll64)
EndIf