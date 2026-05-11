@echo off
setlocal

set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

if exist "%ROOT%\common\set-power.cmd" call "%ROOT%\common\set-power.cmd"
call "%ROOT%\apply\apply.cmd"

endlocal
cmd /k
