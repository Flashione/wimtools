@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

if not exist "%ROOT%\WimTools\startup.cmd" (
    echo ERROR: WimTools startup not found:
    echo %ROOT%\WimTools\startup.cmd
    echo.
    cmd /k
    exit /b 1
)

call "%ROOT%\WimTools\startup.cmd"

endlocal
cmd /k
