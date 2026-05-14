@echo off
setlocal EnableExtensions

title WIM Apply Tool

echo ==========================================
echo  WIM Apply Tool - UEFI / GPT
echo ==========================================
echo.

set "DEFAULT_WIM=%~dp0Images\Recovery.wim"

echo Default image path:
echo %DEFAULT_WIM%
echo.

set /p WIM=Enter WIM image path or press ENTER to use default: 

if "%WIM%"=="" set "WIM=%DEFAULT_WIM%"

if not exist "%WIM%" (
    echo.
    echo ERROR: WIM image not found:
    echo %WIM%
    echo.
    pause
    exit /b 1
)

echo.
echo Selected image:
echo %WIM%
echo.

echo ==========================================
echo  Available disks and volumes
echo ==========================================
echo.

(
echo list disk
echo list volume
echo exit
) > "%temp%\list_disks.txt"

diskpart /s "%temp%\list_disks.txt"

echo.
echo ==========================================
echo  WARNING
echo ==========================================
echo The selected disk will be completely erased.
echo All existing data and partitions will be deleted.
echo.

set /p DISK=Enter target disk number, for example 0 or 1: 

if "%DISK%"=="" (
    echo.
    echo ERROR: No disk selected.
    pause
    exit /b 1
)

echo.
echo Target disk: %DISK%
echo Image file:  %WIM%
echo.

set /p "DUMMY=Press ENTER to erase the selected disk and start restore, or close this window to cancel: "

echo.
echo Creating UEFI/GPT partition layout...
echo.

(
echo rem == CreatePartitions UEFI ==
echo select disk %DISK%
echo clean
echo convert gpt
echo rem == 1. EFI System partition =====================
echo create partition efi size=200
echo format quick fs=fat32 label="System"
echo assign letter=S
echo rem == 2. Windows partition ========================
echo create partition primary
echo format quick fs=ntfs label="Windows"
echo assign letter=W
echo list volume
echo exit
) > "%temp%\restore_diskpart.txt"

diskpart /s "%temp%\restore_diskpart.txt"

if errorlevel 1 (
    echo.
    echo ERROR: Disk partitioning failed.
    pause
    exit /b 1
)

echo.
echo Applying Windows image to W:\ ...
echo.

dism /Apply-Image /ImageFile:"%WIM%" /Index:1 /ApplyDir:W:\ /CheckIntegrity

if errorlevel 1 (
    echo.
    echo ERROR: Image apply failed.
    pause
    exit /b 1
)

echo.
echo Writing bootloader...
echo.

bcdboot W:\Windows /s S: /f ALL

if errorlevel 1 (
    echo.
    echo ERROR: Bootloader creation failed.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo  Apply completed successfully.
echo ==========================================
echo.
echo EFI partition:     S:
echo Windows partition: W:
echo.
echo You can now reboot the system.
echo.

pause
endlocal