@echo off
setlocal enabledelayedexpansion

:: --- COLORS ---
set "Gld=[93m" & set "Blu=[94m" & set "Red=[91m" & set "Grn=[92m" & set "Rst=[0m"

:: --- SETUP ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "chatlog=%vault%\Bzip_Chat.txt"
set "ver=34.9"

:: --- CLOUD REGS ---
set "github_raw=https://githubusercontent.com"
:: NEW CLEAN VAULT ID
set "cloud_id=bzip_vault_final_shield"

:: --- SILENT AUTO-UPDATE ---
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing -ErrorAction SilentlyContinue; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches; if($newVer -gt [float]!ver!){ exit 1 } else { exit 0 } } else { exit 0 }" >nul 2>&1
if %errorlevel% EQU 1 (
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_Update.bat'"
    echo @echo off > updater.bat
    echo timeout /t 1 ^>nul >> updater.bat
    echo del "%~f0" >> updater.bat
    echo ren "Bzip_Update.bat" "Bzip.bat" >> updater.bat
    echo start "" "Bzip.bat" >> updater.bat
    echo del updater.bat >> updater.bat
    start /b "" updater.bat
    exit
)

:: --- DEFAULT SETTINGS ---
set "chat_tag=NONE"
set "pass_bypass=ON"
set "accent=%Gld%"
if exist "%config%" for /f "usebackq tokens=1,2 delims==" %%a in ("%config%") do set "%%a=%%b"

mode con: cols=120 lines=45
title Bzip ENGINE [!ver!]
chcp 65001 >nul

:: --- BYPASS CHECK ---
if /i "%pass_bypass%"=="ON" (set "access_level=Guest" & set "stat_msg=%Grn%GUEST MODE%Rst%" & goto menu)

:password
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo                            [ SECURITY CHECK ]
echo %accent%----------------------------------------------------------------------------%Rst%
set /p "login=  ENTER ACCESS KEY: "
if "%login%"=="232323434343" (set "access_level=Owner" & set "stat_msg=%Red%[ OWNER MODE ]%Rst%" & goto menu)
if "!login!"=="bzip" (set "access_level=User" & set "stat_msg=%Grn%OPERATIONAL%Rst%" & goto menu)
goto password

:menu
cls
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo   [ BZIP GOLD ENGINE ]                                                                        STATUS: !stat_msg!
echo ------------------------------------------------------------------------------------------------------------------------
echo   OFFICIAL OWNER: %accent%EPICWWSHARK%Rst%  (!access_level!)
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo    %Blu%1]%Rst% BUILD 1.8.9      %Blu%5]%Rst% SCREENSHOTS    %accent%[F]%Rst% ASSET FINDER    [K] %Blu%GLOBAL CHAT%Rst%
echo    %Blu%2]%Rst% BUILD 26.1.2     %Blu%6]%Rst% PACK FOLDER    %accent%[P]%Rst% CONVERTER    [S] SETTINGS
echo    %Blu%3]%Rst% AUTO-DEPLOY      %Blu%7]%Rst% PERF STATS     %accent%[R]%Rst% RES CHECK    [X] EXIT
echo.
set /p choice=  %accent%ENTER SELECTION: %Rst%

if /i "!choice!"=="s" goto settings
if /i "!choice!"=="k" goto chat
if /i "!choice!"=="x" exit
goto menu

:chat
cls
echo %accent%[ FILTERING JUNK CODE... ]%Rst%
:: Pure-Text Slicer: Only keeps lines starting with [ (Chat messages)
powershell -Command "$v = Invoke-RestMethod -Uri 'https://workers.dev!'; if($v){ $lines = $v -split \"`n\" | Where-Object { $_ -match '^\\[' }; if($lines){ $lines | Out-File '!chatlog!' } else { 'System: No messages yet.' | Out-File '!chatlog!' } } else { 'System: Vault Empty.' | Out-File '!chatlog!' }" 2>nul
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo                            [ GLOBAL CHAT ]
echo %accent%----------------------------------------------------------------------------%Rst%
if exist "!chatlog!" (type "!chatlog!")
echo.
echo %accent%----------------------------------------------------------------------------%Rst%
echo   TAG: !Blu!!chat_tag!!Rst!
echo   1] Send Message   [R] Refresh   [X] Back
set /p cc= Choice: 

if /i "%cc%"=="r" goto chat
if /i "%cc%"=="x" goto menu
if "%cc%"=="1" (
    if "!chat_tag!"=="NONE" echo !Red!Set a tag in settings!Rst! & pause & goto chat
    set /p "msg= Message: "
    if "%access_level%"=="Owner" (set "line=[OWNER] !chat_tag!: !msg!") else (set "line=[USER] !chat_tag!: !msg!")
    
    :: Safe Send: Forces the cloud to accept the new message list
    powershell -Command "$old = Invoke-RestMethod -Uri 'https://workers.dev!'; if($old -match '<html' -or $old -match '<!DOCTYPE'){$old=''}; $new = $old + \"`n!line!\"; $encoded = [uri]::EscapeDataString($new); Invoke-RestMethod -Uri \"https://workers.dev\"" >nul 2>&1
    timeout /t 1 >nul
    goto chat
)
goto chat

:settings
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo   [ ENGINE SETTINGS ]
echo.
echo  [A] Accent Color
echo  [B] Change Chat Tag: [ !chat_tag! ]
echo  [C] Password Bypass: [ %pass_bypass% ]
echo.
echo  [X] SAVE ^& BACK
echo %accent%----------------------------------------------------------------------------%Rst%
set /p sc= Selection: 
if /i "%sc%"=="x" goto save_config
if /i "%sc%"=="A" (set /p cp= Color: & set "accent=!cp!" & goto settings)
if /i "%sc%"=="B" (set /p chat_tag= New Tag: & goto settings)
if /i "%sc%"=="C" (if /i "%pass_bypass%"=="ON" (set "pass_bypass=OFF") else (set "pass_bypass=ON") & goto settings)
goto settings

:save_config
(echo accent=%accent%& echo chat_tag=%chat_tag%& echo pass_bypass=%pass_bypass%) > "%config%"
goto menu
