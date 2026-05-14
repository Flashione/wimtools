@echo off
setlocal EnableExtensions

title Create WimTools USB

echo ==========================================
echo  Create WimTools USB
echo ==========================================
echo.

echo ==========================================
echo  Available disks and volumes
echo ==========================================
echo.

(
echo list disk
echo list volume
) > "%temp%\list_usb_disks.txt"

diskpart /s "%temp%\list_usb_disks.txt"

echo.
echo ==========================================
echo  WARNING
echo ==========================================
echo The selected disk will be completely erased.
echo All existing partitions and data will be deleted.
echo.
echo Partition layout:
echo   1. FAT32  2 GB   Label: BOOT
echo   2. NTFS   Rest   Label: WIMTOOLS
echo.

set /p DISK=Enter target USB disk number, for example 1: 

echo.
echo Target disk: %DISK%
echo.

set /p CONFIRM=Type CREATEUSB to continue: 

if /I not "%CONFIRM%"=="CREATEUSB" (
    echo.
    echo Operation cancelled.
    pause
    exit /b 0
)

echo.
echo Creating USB partition layout...
echo.

(
echo select disk %DISK%
echo clean
echo convert mbr
echo create partition primary size=2048
echo select partition 1
echo active
echo format quick fs=fat32 label="BOOT"
echo assign
echo create partition primary
echo select partition 2
echo format quick fs=ntfs label="WIMTOOLS"
echo assign
echo list volume
echo exit
) > "%temp%\create_wimtools_usb.txt"

diskpart /s "%temp%\create_wimtools_usb.txt"

if errorlevel 1 (
    echo.
    echo ERROR: USB partitioning failed.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo  USB stick created successfully.
echo ==========================================
echo.
echo FAT32 partition: BOOT     2 GB
echo NTFS partition:  WIMTOOLS Rest of drive
echo.
echo Copy your WinPE boot files to the FAT32 partition.
echo Copy the WimTools folder to the NTFS partition.
echo.

pause
endlocal