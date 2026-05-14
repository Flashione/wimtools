@echo off
setlocal EnableExtensions

title WimTools Customer Restore

set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

set "WIM=%ROOT%\Recovery.wim"

cls
echo ==========================================
echo  WimTools Customer Restore
echo ==========================================
echo.

echo Recovery image:
echo %WIM%
echo.

if not exist "%WIM%" (
    echo ERROR: Recovery.wim not found.
    echo.
    echo Expected:
    echo %WIM%
    echo.
    pause
    exit /b 1
)

echo ==========================================
echo  Available disks and volumes
echo ==========================================
echo.

(
echo list disk
echo list volume
echo exit
) > "%temp%\restore_list.txt"

diskpart /s "%temp%\restore_list.txt"

echo.
echo ==========================================
echo  WARNING
echo ==========================================
echo The selected disk will be completely erased.
echo All existing partitions and data will be deleted.
echo.
echo Partition layout:
echo   EFI      200 MB   FAT32   S:
echo   Windows  Rest     NTFS    W:
echo.

set "DISK="
set /p DISK=Enter target disk number, for example 0 or 1: 

if "%DISK%"=="" (
    echo.
    echo ERROR: No disk selected.
    pause
    exit /b 1
)

echo.
echo Target disk: %DISK%
echo Image:       %WIM%
echo.

set "CONFIRM="
set /p CONFIRM=Type ERASE to continue: 

if /I not "%CONFIRM%"=="ERASE" (
    echo.
    echo Restore cancelled.
    pause
    exit /b 0
)

echo.
echo Creating partition layout...
echo.

(
echo select disk %DISK%
echo clean
echo convert gpt
echo create partition efi size=200
echo format quick fs=fat32 label="System"
echo assign letter=S
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
echo Applying Windows image...
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
echo  Restore completed successfully.
echo ==========================================
echo.
echo Press any key to reboot.
echo.

pause
wpeutil reboot
exit /b 0