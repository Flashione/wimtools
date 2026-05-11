@echo off
setlocal

rem WimTools WinPE build helper.
rem Run from "Deployment and Imaging Tools Environment" as Administrator.

set "WORKDIR=C:\WinPE_amd64"
set "MOUNT=%WORKDIR%\mount"
set "MEDIA=%WORKDIR%\media"
set "OC=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs"

echo.
echo WimTools WinPE build helper
echo ===========================
echo.

where copype >nul 2>&1
if errorlevel 1 (
    echo ERROR: copype was not found.
    echo Run this script from the Deployment and Imaging Tools Environment.
    exit /b 1
)

if not exist "%OC%" (
    echo ERROR: WinPE optional components folder not found:
    echo %OC%
    echo Install the Windows PE Add-on for the ADK first.
    exit /b 1
)

if exist "%WORKDIR%" (
    echo Existing build directory found:
    echo %WORKDIR%
    echo.
    echo Remove it manually before rebuilding.
    exit /b 1
)

echo Creating WinPE working directory...
copype amd64 "%WORKDIR%"
if errorlevel 1 exit /b 1

echo.
echo Mounting boot.wim...
Dism /Mount-Image /ImageFile:"%MEDIA%\sources\boot.wim" /Index:1 /MountDir:"%MOUNT%"
if errorlevel 1 exit /b 1

echo.
echo Adding WinPE optional components...
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-WMI.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-NetFx.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-Scripting.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-SecureStartup.cab"
Dism /Add-Package /Image:"%MOUNT%" /PackagePath:"%OC%\WinPE-SecureBootCmdlets.cab"

echo.
echo Copying WimTools startnet.cmd into mounted image...
copy /y "%~dp0..\pe\startnet.cmd" "%MOUNT%\Windows\System32\startnet.cmd"
if errorlevel 1 exit /b 1

echo.
echo Installed WinPE packages:
Dism /Image:"%MOUNT%" /Get-Packages | findstr /i "WinPE"

echo.
echo Committing boot.wim...
Dism /Unmount-Image /MountDir:"%MOUNT%" /Commit
if errorlevel 1 exit /b 1

echo.
echo Build completed.
echo WinPE media folder:
echo %MEDIA%
echo.
echo Copy the contents of the media folder to the FAT32 boot partition.
echo Copy the repository WimTools folder to the NTFS data partition.
echo.

endlocal
