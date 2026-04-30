@echo off
setlocal enabledelayedexpansion

:: --- SYSTEM BOOT: ANSI COLORS ---
set "Gld=[93m" & set "Blu=[94m" & set "Red=[91m" & set "Grn=[92m" & set "Wht=[97m" & set "Rst=[0m"

:: --- FOLDER SETUP ---
set "vault=%localappdata%\BzipEngine"
if not exist "%vault%" md "%vault%"
set "config=%vault%\Bzip_Settings.cfg"
set "todofile=%vault%\Bzip_ToDo.txt"
set "ver=25.0"

:: --- GITHUB AUTO-PILOT ---
set "github_raw=https://githubusercontent.com"
:: Silent Update Check
powershell -Command "$web = Invoke-WebRequest -Uri '!github_raw!' -UseBasicParsing; if($web.Content -match 'set \"ver=([0-9.]+)\"'){ $newVer = [float]$matches[1]; if($newVer -gt [float]!ver!){ exit 1 } else { exit 0 } }" >nul 2>&1
if %errorlevel% EQU 1 (
    powershell -Command "Invoke-WebRequest -Uri '!github_raw!' -OutFile 'Bzip_Update.bat'"
    echo @echo off > updater.bat
    echo timeout /t 1 /nobreak ^>nul >> updater.bat
    echo del "%~nx0" >> updater.bat
    echo ren "Bzip_Update.bat" "%~nx0" >> updater.bat
    echo start "" "%~nx0" >> updater.bat
    echo del updater.bat >> updater.bat
    start /b "" updater.bat
    exit
)

:: --- DEFAULT SETTINGS ---
set "accent=%Gld%"
set "owner_display=EPICWWSHARK"
set "user_key=202020"
set "printer_access=OFF"
set "beep=ON"

:: Load Settings
if exist "%config%" (for /f "usebackq tokens=1,2 delims==" %%a in ("%config%") do set "%%a=%%b") >nul 2>&1

:: Window Setup
mode con: cols=120 lines=45
title Bzip ENGINE [!ver!]
chcp 65001 >nul

:password
cls
echo !accent!----------------------------------------------------------------------------!Rst!
echo                            [ SECURITY CHECK ]
echo !accent!----------------------------------------------------------------------------!Rst!
echo.
set /p "login=  !accent!ENTER ACCESS KEY: !Rst!"
if "%login%"=="232323434343" (set "access_level=Owner" & set "stat_msg=!Red![ OWNER MODE ]!Rst!" & goto menu)
if "%login%"=="!user_key!" (set "access_level=User" & set "stat_msg=!Grn!OPERATIONAL!Rst!" & goto menu)
if "%login%"=="202020" (set "access_level=User" & set "stat_msg=!Grn!OPERATIONAL!Rst!" & goto menu)
echo !Red!Invalid Key.!Rst! & timeout /t 2 >nul & goto password

:menu
cls
echo !accent!------------------------------------------------------------------------------------------------------------------------!Rst!
echo   [ BZIP GOLD ENGINE ]                                                                        STATUS: !stat_msg!
echo !accent!------------------------------------------------------------------------------------------------------------------------!Rst!
echo   OFFICIAL OWNER: !accent!!owner_display!!Rst!  (!access_level!)
echo !accent!------------------------------------------------------------------------------------------------------------------------!Rst!
echo.
echo    !Blu!1]!Rst! BUILD FULL 1.8.9        !Blu!5]!Rst! OPEN SCREENSHOTS       !accent![F]!Rst! ASSET FINDER
echo    !Blu!2]!Rst! BUILD FULL 26.1.2       !Blu!6]!Rst! PACK FOLDER            !accent![P]!Rst! VERSION CONVERTER
echo    !Blu!3]!Rst! AUTO-DEPLOY ZIP         !Blu!7]!Rst! PERFORMANCE            !accent![R]!Rst! RESOLUTION CHECKER
echo    !Blu!4]!Rst! DEBUG: GAME LOGS        !Blu!8]!Rst! TO-DO LIST             !accent![L]!Rst! LANG FILE GEN
echo.
echo    !accent![S]!Rst! ENGINE SETTINGS                 !accent![C]!Rst! CLEAN WORKSPACE               !Red![X]!Rst! EXIT APP
echo.
set /p choice=  !accent!ENTER SELECTION: !Rst!

if /i "!choice!"=="s" goto settings
if /i "!choice!"=="8" goto todo
if /i "!choice!"=="7" goto performance
if /i "!choice!"=="x" exit
goto menu

:settings
cls
echo !accent!----------------------------------------------------------------------------!Rst!
echo   [ ENGINE SETTINGS ] - Access: !access_level!
echo !accent!----------------------------------------------------------------------------!Rst!
echo.
echo   !Wht![ USER PARTITION ]!Rst!
echo   A] Change Accent Color      B] Toggle Startup Beep: !beep!
echo   C] Change YOUR Login Key    D] Reset Defaults
echo.
echo   !Wht![ PRINTER PARTITION ]!Rst!
echo   E] Printer Access: !printer_access!
echo.
if "!access_level!"=="Owner" (
    echo   !Red![ OWNER PARTITION ]!Rst!
    echo   G] Set Owner Display Name   H] Emergency Factory Reset
)
echo.
echo   !accent![X]!Rst! SAVE ^& BACK HOME
echo !accent!----------------------------------------------------------------------------!Rst!
set /p sc= Selection: 

if /i "%sc%"=="x" (
    (echo accent=!accent!& echo printer_access=!printer_access!& echo user_key=!user_key!& echo owner_display=!owner_display!& echo beep=!beep!) > "%config%"
    goto menu
)
if /i "%sc%"=="A" (set /p cp= Color Name: & if /i "!cp!"=="Red" set "accent=%Red%" & goto settings)
if /i "%sc%"=="B" (if "!beep!"=="ON" (set "beep=OFF") else (set "beep=ON") & goto settings)
if /i "%sc%"=="E" (if "!printer_access!"=="ON" (set "printer_access=OFF") else (set "printer_access=ON") & goto settings)

if "!access_level!"=="Owner" (
    if /i "%sc%"=="G" (set /p owner_display= New Name: & goto settings)
    if /i "%sc%"=="H" (del "%config%" & exit)
)
goto settings

:todo
cls
echo !accent!----------------------------------------------------------------------------!Rst!
echo   [ BZIP TO-DO LIST ]
echo !accent!----------------------------------------------------------------------------!Rst!
if exist "%todofile%" (type "%todofile%") else (echo [List Empty])
echo.
echo  1] Add  2] Delete Note  3] !Blu!Print Notes!Rst!  [X] Back
set /p tc= Action: 
if "%tc%"=="1" (set /p "n=Note: " & echo - !n! >> "%todofile%" & goto todo)
if "%tc%"=="2" (if exist "%todofile%" del "%todofile%" & goto todo)
if "%tc%"=="3" (
    if "!printer_access!"=="OFF" (echo !Red!PRINTER DISABLED IN SETTINGS.!Rst! & pause & goto todo)
    copy /y "%todofile%" "%userprofile%\Desktop\Bzip_Notes.txt" >nul
    echo !Grn!Notes printed to Desktop.!Rst! & pause & goto todo
)
if /i "%tc%"=="x" goto menu
goto todo

:performance
cls
powershell -Command "(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory | ForEach-Object { Write-Host \"RAM Free: \" ([math]::Round($_ / 1MB, 2)) \"GB\" }"
echo.
echo  !Blu!P]!Rst! Print Report   !accent![X]!Rst! Back
set /p pc= Choice: 
if /i "%pc%"=="p" (
    if "!printer_access!"=="OFF" (echo !Red!PRINTER DISABLED.!Rst! & pause & goto performance)
    echo BZIP STATUS REPORT > "%userprofile%\Desktop\Bzip_Perf.txt"
    echo !Grn!Report sent to Desktop.!Rst! & pause
)
goto menu
