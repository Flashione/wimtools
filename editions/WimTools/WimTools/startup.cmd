@echo off
setlocal

set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

if exist "%ROOT%\common\set-power.cmd" call "%ROOT%\common\set-power.cmd"

echo.
echo WimTools
echo ========
echo.
echo 1 - WimApply
echo 2 - WimCapture
echo 3 - Command Prompt
echo 4 - Reboot
echo 5 - Shutdown
echo.

choice /c 12345 /m "Select option"

if errorlevel 5 wpeutil shutdown
if errorlevel 4 wpeutil reboot
if errorlevel 3 cmd /k
if errorlevel 2 call "%ROOT%\capture\capture.cmd"
if errorlevel 1 call "%ROOT%\apply\apply.cmd"

endlocal
cmd /k
