@echo off
setlocal enabledelayedexpansion

:: --- COLORS ---
set "Gld=[93m" & set "Blu=[94m" & set "Red=[91m" & set "Grn=[92m" & set "Wht=[97m" & set "Rst=[0m"

:: --- SETUP ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "keyfile=%vault%\Bzip_Key.sys"
set "chatlog=%vault%\Bzip_Chat.txt"
set "ver=32.0"

:: --- CLOUD LINKS (FIXED) ---
set "github_raw=https://githubusercontent.com"
set "chat_url=https://githubusercontent.com"

:: --- SILENT AUTO-UPDATE ---
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches[1]; if($newVer -gt [float]!ver!){ exit 1 } else { exit 0 } }" >nul 2>&1
if %errorlevel% EQU 1 (
    cls
    echo -----------------------------------------------------------
    echo  [!] NEW VERSION FOUND. DOWNLOADING UPDATE...
    echo -----------------------------------------------------------
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_Update.bat'"
    echo @echo off > updater.bat
    echo timeout /t 1 ^>nul >> updater.bat
    echo del "%~nx0" >> updater.bat
    echo ren "Bzip_Update.bat" "%~nx0" >> updater.bat
    echo start "" "%~nx0" >> updater.bat
    echo del updater.bat >> updater.bat
    start /b "" updater.bat
    exit
)

:: --- DEFAULT SETTINGS ---
set "accent=%Gld%"
set "chat_tag=NONE"
set "pass_bypass=ON"

if exist "%config%" for /f "usebackq tokens=1,2 delims==" %%a in ("%config%") do set "%%a=%%b"
if not exist "%keyfile%" echo bzip>"%keyfile%"
set /p user_key=<"%keyfile%"
set "user_key=!user_key: =!"

:: Window Setup
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
set "login="
set /p "login=  ENTER ACCESS KEY: "
if "%login%"=="232323434343" (set "access_level=Owner" & set "stat_msg=%Red%[ OWNER MODE ]%Rst%" & goto menu)
if "!login!"=="!user_key!" (set "access_level=User" & set "stat_msg=%Grn%OPERATIONAL%Rst%" & goto menu)
goto password

:menu
cls
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo   [ BZIP GOLD ENGINE ]                                                                        STATUS: !stat_msg!
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo   OFFICIAL OWNER: %accent%EPICWWSHARK%Rst%  (!access_level!)
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo.
echo    %Blu%1]%Rst% BUILD 1.8.9      %Blu%5]%Rst% SCREENSHOTS    %accent%[F]%Rst% ASSET FINDER    [K] GLOBAL CHAT
echo    %Blu%2]%Rst% BUILD 26.1.2     %Blu%6]%Rst% PACK FOLDER    %accent%[P]%Rst% CONVERTER    [S] SETTINGS
echo    %Blu%3]%Rst% AUTO-DEPLOY      %Blu%7]%Rst% PERF STATS     %accent%[R]%Rst% RES CHECK    [C] CLEAN
echo    %Blu%4]%Rst% DEBUG LOGS       %Blu%8]%Rst% TO-DO LIST     %accent%[L]%Rst% LANG GEN      %Red%[X]%Rst% EXIT
echo.
set /p choice=  %accent%ENTER SELECTION: %Rst%

if /i "!choice!"=="s" goto settings
if /i "!choice!"=="k" goto chat
if /i "!choice!"=="x" exit
if "!choice!"=="1" set "pver=1" & set "fname=1.8.9 template" & goto create
if "!choice!"=="2" set "pver=45" & set "fname=26.1.2 template" & goto create
goto menu

:chat
cls
echo %accent%[ CLOUD CHAT - SYNCING... ]%Rst%
powershell -Command "Invoke-WebRequest -Uri '!chat_url!' -OutFile '!chatlog!'" 2>nul
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo                            [ GLOBAL CHAT ]
echo %accent%----------------------------------------------------------------------------%Rst%
if exist "!chatlog!" (type "!chatlog!") else (echo [ No Messages Yet ])
echo %accent%----------------------------------------------------------------------------%Rst%
echo   TAG: !Blu!!chat_tag!!Rst!
echo   1] Send Message   2] Change Tag   [X] Back
set /p cc= Choice: 
if "%cc%"=="1" (
    if "!chat_tag!"=="NONE" echo !Red!Set a tag first!Rst! & pause & goto chat
    set /p "msg= Message: "
    if "%access_level%"=="Owner" (set "line=%Red%[OWNER] !chat_tag!%Rst%: !msg!") else (set "line=[USER] !chat_tag!: !msg!")
    echo !line! >> "!chatlog!"
    goto chat
)
if "%cc%"=="2" (set /p "chat_tag= New Tag: " & goto chat)
if /i "%cc%"=="x" goto menu
goto chat

:settings
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo   [ ENGINE SETTINGS ]
echo  [A] Accent Color      [C] Password Bypass: %pass_bypass%
echo  [B] Change Password   [D] RESET ENGINE
echo.
echo  [X] SAVE ^& BACK
set /p sc= Selection: 
if /i "%sc%"=="x" goto save_config
if /i "%sc%"=="A" (set /p cp= Color: & set "accent=!cp!" & goto settings)
if /i "%sc%"=="C" (if "%pass_bypass%"=="ON" (set "pass_bypass=OFF") else (set "pass_bypass=ON") & goto settings)
goto settings

:save_config
(echo accent=%accent%& echo chat_tag=%chat_tag%& echo pass_bypass=%pass_bypass%) > "%config%"
goto menu

:create
cls
md "temp\assets\minecraft\textures" 2>nul
(echo {"pack":{"pack_format":%pver%,"description":"Bzip Template"}}) > "temp\pack.mcmeta"
powershell -command "Compress-Archive -Path 'temp\*' -DestinationPath '%fname%.zip' -Force"
rd /s /q "temp"
echo Done! & pause & goto menu
