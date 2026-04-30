@echo off
setlocal enabledelayedexpansion

:: --- COLORS ---
set "Gld=[93m" & set "Blu=[94m" & set "Red=[91m" & set "Grn=[92m" & set "Wht=[97m" & set "Rst=[0m"

:: --- SETUP ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "ver=36.0"

:: --- CLOUD LINKS ---
set "github_raw=https://githubusercontent.com"

:: --- AUTO-UPDATE ENGINE ---
title Bzip ENGINE [Checking Cloud...]
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing -ErrorAction SilentlyContinue; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches; if($newVer -gt [float]!ver!){ exit 1 } else { exit 0 } } else { exit 0 }" >nul 2>&1
if %errorlevel% EQU 1 (
    cls
    echo !accent!-----------------------------------------------------------!Rst!
    echo  [!] NEW VERSION DETECTED. UPDATING ENGINE...
    echo !accent!-----------------------------------------------------------!Rst!
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_New.bat' -ErrorAction SilentlyContinue"
    echo @echo off > updater.bat
    echo timeout /t 1 ^>nul >> updater.bat
    echo del "%~f0" >> updater.bat
    echo ren "Bzip_New.bat" "Bzip.bat" >> updater.bat
    echo start "" "Bzip.bat" >> updater.bat
    echo del updater.bat >> updater.bat
    start /b "" updater.bat
    exit
)

:: --- DEFAULT SETTINGS ---
set "accent=%Gld%"
set "pass_bypass=ON"
if exist "%config%" for /f "usebackq tokens=1,2 delims==" %%a in ("%config%") do set "%%a=%%b"

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
if /i "!choice!"=="8" goto todo
if /i "!choice!"=="x" exit
if "!choice!"=="1" set "pver=1" & set "fname=1.8.9 template" & goto create
if "!choice!"=="2" set "pver=45" & set "fname=26.1.2 template" & goto create
goto menu

:settings
cls
echo %accent%----------------------------------------------------------------------------%Rst%
echo   [ ENGINE SETTINGS ]
echo %accent%----------------------------------------------------------------------------%Rst%
echo.
echo  [A] Accent Color
echo  [B] Password Bypass: [ %pass_bypass% ]
echo.
echo  [X] SAVE ^& BACK
echo %accent%----------------------------------------------------------------------------%Rst%
set /p sc= Selection: 

if /i "%sc%"=="x" goto save_config
if /i "%sc%"=="A" (set /p cp= Color: & set "accent=!cp!" & goto settings)
if /i "%sc%"=="B" (if /i "%pass_bypass%"=="ON" (set "pass_bypass=OFF") else (set "pass_bypass=ON") & goto settings)
goto settings

:save_config
(echo accent=%accent%& echo pass_bypass=%pass_bypass%) > "%config%"
goto menu

:todo
cls
echo %accent%[ BZIP TO-DO LIST ]%Rst%
set "todofile=%vault%\Bzip_ToDo.txt"
if exist "!todofile!" (type "!todofile!") else (echo Your list is empty.)
echo.
echo [1] Add Note  [2] Clear All  [X] Back
set /p tc= Choice: 
if "%tc%"=="1" (set /p "n=Note: " & echo - !n! >> "!todofile!" & goto todo)
if "%tc%"=="2" (del "!todofile!" & goto todo)
goto menu

:create
cls
md "temp" 2>nul
echo Done! & pause & goto menu
