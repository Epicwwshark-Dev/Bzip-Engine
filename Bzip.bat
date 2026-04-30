@echo off
setlocal enabledelayedexpansion

:: --- SYSTEM BOOT ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "ver=24.0"

:: --- GITHUB LINK ---
:: We will put your real link here in the next step!
set "github_raw=PASTE_LINK_HERE"

:: --- AUTO-UPDATE ENGINE ---
title Bzip ENGINE [Checking for Updates...]
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches[1]; if($newVer -gt [float]!ver!){ exit 1 } else { exit 0 } }" >nul 2>&1

if %errorlevel% EQU 1 (
    echo [!] NEW VERSION FOUND. UPDATING...
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_New.bat'"
    echo @echo off > update.bat
    echo timeout /t 1 /nobreak ^>nul >> update.bat
    echo del "%~nx0" >> update.bat
    echo ren "Bzip_New.bat" "%~nx0" >> update.bat
    echo start "" "%~nx0" >> update.bat
    echo del update.bat >> update.bat
    start /b "" update.bat
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
echo   VERSION: !ver!                                                                               TYPE: JAVA ENGINE
echo ------------------------------------------------------------------------------------------------------------------------
echo   OFFICIAL OWNER: !owner_display!  (!access_level!)
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo    1] BUILD FULL 1.8.9      5] SCREENSHOTS    F] ASSET FINDER
echo    2] BUILD FULL 26.1.2     6] PACK FOLDER    P] VERSION CONVERTER
echo    3] AUTO-DEPLOY           7] PERF STATS     R] RESOLUTION CHECKER
echo    4] DEBUG: GAME LOGS      8] TO-DO LIST     L] LANG FILE GEN
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

