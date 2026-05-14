@echo off
setlocal EnableExtensions

title WIM Capture Tool

set "SCRIPT_DIR=%~dp0"

rem Go one level up from WimTools\Capture to WimTools
for %%I in ("%SCRIPT_DIR%..") do set "ROOT=%%~fI"

set "DEFAULT_WIM=%ROOT%\Restore\Images\Recovery.wim"

echo ==========================================
echo  WIM Capture Tool
echo ==========================================
echo.

echo ==========================================
echo  Available volumes
echo ==========================================
echo.

(
echo list volume
echo exit
) > "%temp%\list_volumes.txt"

diskpart /s "%temp%\list_volumes.txt"

echo.
echo Searching for Windows installation...
echo.

set "DEFAULT_SRC="

for %%D in (C: D: E: F: G: H: I: J: K: L: M: N: O: P: Q: R: S: T: U: V: W: Y: Z:) do (
    if /I not "%%D"=="X:" (
        if /I not "%%D"=="%~d0" (
            if exist "%%D\Windows\System32\Config\SYSTEM" (
                if not defined DEFAULT_SRC set "DEFAULT_SRC=%%D"
                echo Windows found on %%D
            )
        )
    )
)

if "%DEFAULT_SRC%"=="" set "DEFAULT_SRC=C:"

echo.
echo ==========================================
echo  Default paths
echo ==========================================
echo Windows location: %DEFAULT_SRC%
echo WIM destination:  %DEFAULT_WIM%
echo.

set /p SRC=Where is Windows located? Press ENTER for %DEFAULT_SRC%: 
if "%SRC%"=="" set "SRC=%DEFAULT_SRC%"

rem Remove trailing backslash if entered, for example W:\ -> W:
if "%SRC:~-1%"=="\" set "SRC=%SRC:~0,-1%"

set /p WIM=Enter WIM destination path or press ENTER to use default: 
if "%WIM%"=="" set "WIM=%DEFAULT_WIM%"

rem If user enters path without .wim, append .wim
for %%I in ("%WIM%") do (
    set "WIMDIR=%%~dpI"
    set "WIMBASE=%%~nI"
    set "WIMEXT=%%~xI"
)

if /I not "%WIMEXT%"==".wim" (
    set "WIM=%WIMDIR%%WIMBASE%.wim"
)

set "IMAGE_NAME=%WIMBASE%"

echo.
echo Checking Windows path...

if not exist "%SRC%\Windows\System32" (
    echo.
    echo ERROR: Windows folder not found:
    echo %SRC%\Windows\System32
    echo.
    echo Check the volume list above and enter the correct Windows drive letter.
    echo.
    pause
    exit /b 1
)

echo.
echo Creating destination folder...
for %%I in ("%WIM%") do mkdir "%%~dpI" 2>nul

echo.
echo ==========================================
echo  Capture summary
echo ==========================================
echo Source:      %SRC%\
echo Destination: %WIM%
echo Image name:  %IMAGE_NAME%
echo.

if not exist "%WIM%" goto STARTCAPTURE

echo WARNING: The destination WIM already exists.
echo Existing file:
echo %WIM%
echo.
set /p "DUMMY=Press ENTER to delete and recreate the WIM, or close this window to cancel: "

echo.
echo Deleting existing WIM...
del /f /q "%WIM%"

if exist "%WIM%" (
    echo.
    echo ERROR: Existing WIM could not be deleted:
    echo %WIM%
    echo.
    pause
    exit /b 1
)

goto STARTCAPTURE


:STARTCAPTURE
echo.
echo Starting capture...
echo.

dism /Capture-Image /ImageFile:"%WIM%" /CaptureDir:%SRC%\ /Name:"%IMAGE_NAME%" /Compress:max /CheckIntegrity

echo.
if %errorlevel% equ 0 (
    echo Capture completed successfully.
) else (
    echo Capture failed. DISM exit code: %errorlevel%
)

echo.
pause
endlocal