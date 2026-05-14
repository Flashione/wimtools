@echo off
setlocal EnableExtensions

title Driver Import Tool

echo ==========================================
echo  Driver Import Tool - Offline Windows
echo ==========================================
echo.

echo ==========================================
echo  Available volumes
echo ==========================================
echo.

(
echo list volume
) > "%temp%\list_volumes.txt"

diskpart /s "%temp%\list_volumes.txt"

echo.
echo ==========================================
echo  Default paths
echo ==========================================
echo Windows location: C:
echo Driver source:    D:\Drivers
echo.

set /p SRC=Where is Windows located? Press ENTER for C: 
if "%SRC%"=="" set "SRC=C:"

set /p DRIVERDRIVE=Where are the drivers located? Press ENTER for D: 
if "%DRIVERDRIVE%"=="" set "DRIVERDRIVE=D:"

set "DRIVERS=%DRIVERDRIVE%\Drivers"

echo.
echo Checking Windows path...

if not exist "%SRC%\Windows\System32" (
    echo.
    echo ERROR: Windows folder not found:
    echo %SRC%\Windows\System32
    echo.
    echo Check the volume list above and enter the correct Windows drive letter.
    pause
    exit /b 1
)

echo.
echo Checking driver source...

if not exist "%DRIVERS%" (
    echo.
    echo ERROR: Driver folder not found:
    echo %DRIVERS%
    echo.
    echo Check the volume list above and enter the correct driver source drive.
    pause
    exit /b 1
)

echo.
echo Starting driver import...
echo Windows location: %SRC%
echo Driver source:    %DRIVERS%
echo.

dism /Image:%SRC%\ /Add-Driver /Driver:"%DRIVERS%" /Recurse

echo.
if %errorlevel% equ 0 (
    echo Driver import completed successfully.
) else (
    echo Driver import failed. DISM exit code: %errorlevel%
)

echo.
pause
endlocal