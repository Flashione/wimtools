@echo off
setlocal EnableExtensions

title Driver Export Tool

echo ==========================================
echo  Driver Export Tool - Offline Windows
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
echo Windows location:   C:
echo Export drive:       D:
echo Export destination: D:\Drivers
echo.

set /p SRC=Where is Windows located? Press ENTER for C: 
if "%SRC%"=="" set "SRC=C:"

set /p DESTDRIVE=Where should the drivers be exported? Press ENTER for D: 
if "%DESTDRIVE%"=="" set "DESTDRIVE=D:"

set "DEST=%DESTDRIVE%\Drivers"

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
echo Creating export destination...
mkdir "%DEST%" 2>nul

echo.
echo Starting driver export...
echo Windows location:   %SRC%
echo Export destination: %DEST%
echo.

dism /Image:%SRC%\ /Export-Driver /Destination:"%DEST%"

echo.
if %errorlevel% equ 0 (
    echo Driver export completed successfully.
) else (
    echo Driver export failed. DISM exit code: %errorlevel%
)

echo.
pause
endlocal