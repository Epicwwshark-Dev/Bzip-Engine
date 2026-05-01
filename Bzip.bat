@echo off
setlocal enabledelayedexpansion

:: --- COLORS ---
set "Gld=[93m" & set "Blu=[94m" & set "Red=[91m" & set "Grn=[92m" & set "Wht=[97m" & set "Rst=[0m"

:: --- SETUP ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "ver=36.1"

:: --- CLOUD LINKS ---
set "github_raw=https://githubusercontent.com"

:: --- AUTO-UPDATE & GLOBAL MAINT CHECK ---
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing -ErrorAction SilentlyContinue; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches; if($newVer -gt [float]!ver!){ exit 1 } } exit 0" >nul 2>&1
if %errorlevel% EQU 1 (
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_Update.bat' -ErrorAction SilentlyContinue"
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
set "accent=%Gld%"
set "pass_bypass=ON"
set "maint_mode=OFF"
set "maint_note=SYSTEM UNDER MAINTENANCE"

if exist "%config%" for /f "usebackq tokens=1,2 delims==" %%a in ("%config%") do set "%%a=%%b"

:: --- MAINTENANCE LOCK ---
if "%maint_mode%"=="ON" (
    cls
    echo %Red%----------------------------------------------------------------------------%Rst%
    echo                            [ SYSTEM LOCKED ]
    echo %Red%----------------------------------------------------------------------------%Rst%
    echo.
    echo  MESSAGE FROM OWNER:
    echo  "%maint_note%"
    echo.
    set /p "m_login=  MASTER KEY TO BYPASS: "
    if "!m_login!"=="232323434343" (set "access_level=Owner" & set "stat_msg=%Red%[ MAINT BYPASS ]%Rst%" & goto menu)
    exit
)

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
set /p "login=  ENTER ACCESS KEY: "
if "%login%"=="232323434343" (set "access_level=Owner" & set "stat_msg=%Red%[ OWNER MODE ]%Rst%" & goto menu)
if "!login!"=="bzip" (set "access_level=User" & set "stat_msg=%Grn%OPERATIONAL%Rst%" & goto menu)
goto password

:menu
cls
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo   [ BZIP GOLD ENGINE ]                                                                        STATUS: !stat_msg!
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo   OFFICIAL OWNER: %accent%EPICWWSHARK%Rst%  (!access_level!)
echo %accent%------------------------------------------------------------------------------------------------------------------------%Rst%
echo.
echo    %Blu%1]%Rst% BUILD 1.8.9      %Blu%5]%Rst% SCREENSHOTS    %accent%[F]%Rst% ASSET FINDER
echo    %Blu%2]%Rst% BUILD 26.1.2     %Blu%6]%Rst% PACK FOLDER    %accent%[P]%Rst% CONVERTER
echo    %Blu%3]%Rst% AUTO-DEPLOY      %Blu%7]%Rst% PERF STATS     %accent%[R]%Rst% RES CHECK
echo    %Blu%4]%Rst% DEBUG LOGS       %Blu%8]%Rst% TO-DO LIST     %accent%[S]%Rst% SETTINGS
echo.
echo                                                                    %Red%[X]%Rst% EXIT APP
echo.
set /p choice=  %accent%ENTER SELECTION: %Rst%

if /i "!choice!"=="s" goto settings
if /i "!choice!"=="x" exit
goto menu

:settings
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo   [ ENGINE SETTINGS ]
echo %accent%----------------------------------------------------------------------------%Rst%
echo.
echo  [A] Accent Color
echo  [B] Password Bypass: [ %pass_bypass% ]
echo  [C] RESET ENGINE
echo.
if "%access_level%"=="Owner" (
    echo  %Red%[ OWNER SETTINGS ]%Rst%
    echo  [D] MAINTENANCE MODE: [ %maint_mode% ]
    echo  [E] EDIT MAINTENANCE NOTE
    echo.
)
echo  [X] SAVE ^& BACK
echo %accent%----------------------------------------------------------------------------%Rst%
set /p sc= Selection: 

if /i "%sc%"=="x" goto save_config
if /i "%sc%"=="A" (set /p cp= Color: & set "accent=!cp!" & goto settings)
if /i "%sc%"=="B" (if /i "%pass_bypass%"=="ON" (set "pass_bypass=OFF") else (set "pass_bypass=ON") & goto settings)
if /i "%sc%"=="C" (del "%config%" & exit)

if "%access_level%"=="Owner" (
    if /i "%sc%"=="D" (if /i "%maint_mode%"=="ON" (set "maint_mode=OFF") else (set "maint_mode=ON") & goto settings)
    if /i "%sc%"=="E" (set /p "maint_note= New Note: " & goto settings)
)
goto settings

:save_config
(
echo accent=%accent%
echo pass_bypass=%pass_bypass%
echo maint_mode=%maint_mode%
echo maint_note=%maint_note%
) > "%config%"
goto menu
