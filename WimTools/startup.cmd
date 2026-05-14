@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

if exist "%ROOT%\common\set-power.cmd" call "%ROOT%\common\set-power.cmd"

if /I "%~1"=="/menu" goto MAINMENU

goto KEYBOARD


:KEYBOARD
cls
echo.
echo Keyboard Layout
echo ===============
echo.
echo 1 - de_CH Swiss German
echo 2 - fr_CH Swiss French
echo 3 - it_CH Italian Switzerland - Swiss keyboard
echo 4 - it_CH Italian keyboard
echo 5 - de_DE German Germany
echo 6 - fr_FR French France
echo 7 - Skip / Default US
echo.

set "KBD="
set /p KBD=Select keyboard layout: 

if "%KBD%"=="1" (
    wpeutil SetKeyboardLayout 0807:00000807
    goto STARTNEWMENU
)

if "%KBD%"=="2" (
    wpeutil SetKeyboardLayout 100C:0000100C
    goto STARTNEWMENU
)

if "%KBD%"=="3" (
    wpeutil SetKeyboardLayout 0810:0000100C
    goto STARTNEWMENU
)

if "%KBD%"=="4" (
    wpeutil SetKeyboardLayout 0810:00000410
    goto STARTNEWMENU
)

if "%KBD%"=="5" (
    wpeutil SetKeyboardLayout 0407:00000407
    goto STARTNEWMENU
)

if "%KBD%"=="6" (
    wpeutil SetKeyboardLayout 040C:0000040C
    goto STARTNEWMENU
)

if "%KBD%"=="7" (
    wpeutil SetKeyboardLayout 0409:00000409
    goto STARTNEWMENU
)

goto KEYBOARD


:STARTNEWMENU
echo.
echo Starting WimTools menu with selected keyboard layout...
echo.

start "WimTools" "%SystemRoot%\System32\cmd.exe" /k call "%~f0" /menu

goto KEYBOARD


:MAINMENU
cls
echo.
echo WimTools
echo ========
echo.
echo 1 - Restore Windows Image
echo 2 - Capture Windows Image
echo 3 - Drivers
echo 4 - Stick Creator
echo 5 - Command Prompt
echo 6 - Reboot
echo 7 - Shutdown
echo.

set "OPTION="
set /p OPTION=Select option: 

if "%OPTION%"=="1" goto RESTORE
if "%OPTION%"=="2" goto CAPTURE
if "%OPTION%"=="3" goto DRIVERS
if "%OPTION%"=="4" goto STICKCREATOR
if "%OPTION%"=="5" goto CMD
if "%OPTION%"=="6" goto REBOOT
if "%OPTION%"=="7" goto SHUTDOWN

goto MAINMENU


:RESTORE
cls
echo.
echo Starting Restore...
echo.

if exist "%ROOT%\Restore\WimApply.cmd" (
    call "%ROOT%\Restore\WimApply.cmd"
) else (
    echo ERROR: Restore script not found:
    echo %ROOT%\Restore\WimApply.cmd
    echo.
    pause
)

goto MAINMENU


:CAPTURE
cls
echo.
echo Starting Capture...
echo.

if exist "%ROOT%\Capture\WimCapture.cmd" (
    call "%ROOT%\Capture\WimCapture.cmd"
) else (
    echo ERROR: Capture script not found:
    echo %ROOT%\Capture\WimCapture.cmd
    echo.
    pause
)

goto MAINMENU


:DRIVERS
cls
echo.
echo Driver Tools
echo ============
echo.
echo 1 - Export Drivers
echo 2 - Import Drivers
echo 3 - Back
echo.

set "DRIVEROPTION="
set /p DRIVEROPTION=Select option: 

if "%DRIVEROPTION%"=="1" goto EXPORTDRIVERS
if "%DRIVEROPTION%"=="2" goto IMPORTDRIVERS
if "%DRIVEROPTION%"=="3" goto MAINMENU

goto DRIVERS


:EXPORTDRIVERS
cls
echo.
echo Starting Driver Export...
echo.

if exist "%ROOT%\drivers\export-drivers.cmd" (
    call "%ROOT%\drivers\export-drivers.cmd"
) else (
    echo ERROR: Driver export script not found:
    echo %ROOT%\drivers\export-drivers.cmd
    echo.
    pause
)

goto DRIVERS


:IMPORTDRIVERS
cls
echo.
echo Starting Driver Import...
echo.

if exist "%ROOT%\drivers\import-drivers.cmd" (
    call "%ROOT%\drivers\import-drivers.cmd"
) else (
    echo ERROR: Driver import script not found:
    echo %ROOT%\drivers\import-drivers.cmd
    echo.
    pause
)

goto DRIVERS


:STICKCREATOR
cls
echo.
echo Starting Stick Creator...
echo.

if exist "%ROOT%\StickCreator\Create-WimTools-USB.cmd" (
    call "%ROOT%\StickCreator\Create-WimTools-USB.cmd"
) else (
    echo ERROR: Stick Creator script not found:
    echo %ROOT%\StickCreator\Create-WimTools-USB.cmd
    echo.
    pause
)

goto MAINMENU


:CMD
cls
echo.
echo Opening Command Prompt...
echo Type exit to return to WimTools.
echo.
cmd
goto MAINMENU


:REBOOT
wpeutil reboot
goto MAINMENU


:SHUTDOWN
wpeutil shutdown
goto MAINMENU