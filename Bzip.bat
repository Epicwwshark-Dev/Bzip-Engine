@echo off
setlocal enabledelayedexpansion

:: --- SYSTEM BOOT ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "ver=24.0"

:: --- YOUR OFFICIAL GITHUB LINK ---
set "github_raw=https://raw.githubusercontent.com/Epicwwshark-Dev/Bzip-Engine/refs/heads/main/Bzip.bat"

:: --- AUTO-UPDATE ENGINE ---
title Bzip ENGINE [Checking for Updates...]
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches[1]; if($newVer -gt [float]!ver!){ exit 1 } else { exit 0 } }" >nul 2>&1

if %errorlevel% EQU 1 (
    cls
    echo -----------------------------------------------------------
    echo  [!] NEW VERSION FOUND. DOWNLOADING UPDATE...
    echo -----------------------------------------------------------
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_Update.bat'"
    echo @echo off > updater.bat
    echo timeout /t 2 /nobreak ^>nul >> updater.bat
    echo del "%~nx0" >> updater.bat
    echo ren "Bzip_Update.bat" "%~nx0" >> updater.bat
    echo start "" "%~nx0" >> updater.bat
    echo del updater.bat >> updater.bat
    start /b "" updater.bat
    exit
)

:: --- LOAD SETTINGS ---
set "maincol=0B"
set "owner_display=EPICWWSHARK"
set "user_key=202020"
if exist "%config%" (for /f "usebackq tokens=1,2 delims==" %%a in ("%config%") do set "%%a=%%b") >nul 2>&1

mode con: cols=120 lines=45
color !maincol!
title Bzip ENGINE [!ver!]

:password
cls
echo ----------------------------------------------------------------------------
echo                            [ SECURITY CHECK ]
echo ----------------------------------------------------------------------------
echo.
set /p "login=  ENTER ACCESS KEY: "
if "!login!"=="232323434343" (set "access_level=Owner" & set "stat_msg=OWNER MODE" & goto menu)
if "!login!"=="!user_key!" (set "access_level=User" & set "stat_msg=OPERATIONAL" & goto menu)
if "!login!"=="202020" (set "access_level=User" & set "stat_msg=OPERATIONAL" & goto menu)
goto password

:menu
cls
echo ------------------------------------------------------------------------------------------------------------------------
echo   [ BZIP GOLD ENGINE ]                                                                        STATUS: !stat_msg!
echo ------------------------------------------------------------------------------------------------------------------------
echo   OFFICIAL OWNER: !owner_display!  (!access_level!)
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo    1] BUILD FULL 1.8.9      5] SCREENSHOTS    F] ASSET FINDER
echo    2] BUILD FULL 26.1.2     6] PACK FOLDER    P] VERSION CONVERTER
echo    3] AUTO-DEPLOY           7] PERF STATS     R] RESOLUTION CHECKER
echo    4] DEBUG: VIEW LOGS      8] TO-DO LIST     L] LANG FILE GEN
echo.
echo    S] ENGINE SETTINGS       C] CLEAN          X] EXIT
echo.
set /p choice=  ENTER SELECTION: 

if /i "!choice!"=="s" goto settings
if /i "!choice!"=="x" exit
goto menu

:settings
cls
echo [ ENGINE SETTINGS ]
echo  A] Color  B] Login Key  [X] SAVE ^& BACK
set /p sc= Selection: 
if /i "!sc!"=="x" ((echo maincol=!maincol!& echo user_key=!user_key!& echo owner_display=!owner_display!) > "%config%" & goto menu)
goto settings
