# WinPE Build

This document describes how to build the WimTools WinPE baseline from official Microsoft sources.

## 1. Download Microsoft tools

Download:

- Windows ADK: https://go.microsoft.com/fwlink/?linkid=2337875
- Windows PE Add-on for the ADK: https://go.microsoft.com/fwlink/?linkid=2337681

Install the ADK first.

Required ADK feature:

```text
Deployment Tools
```

Then install the Windows PE Add-on.

## 2. Open the correct command environment

Open as Administrator:

```text
Deployment and Imaging Tools Environment
```

## 3. Create WinPE working directory

```cmd
copype amd64 C:\WinPE_amd64
```

## 4. Mount boot.wim

```cmd
Dism /Mount-Image ^
 /ImageFile:C:\WinPE_amd64\media\sources\boot.wim ^
 /Index:1 ^
 /MountDir:C:\WinPE_amd64\mount
```

## 5. Add optional components

Set paths:

```cmd
set OC=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs
set MOUNT=C:\WinPE_amd64\mount
```

Add components:

```cmd
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-WMI.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-NetFx.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-Scripting.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-PowerShell.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-SecureStartup.cab"
Dism /Add-Package /Image:%MOUNT% /PackagePath:"%OC%\WinPE-SecureBootCmdlets.cab"
```

## 6. Copy startnet.cmd

Copy the repository version into the mounted image:

```cmd
copy /y pe\startnet.cmd C:\WinPE_amd64\mount\Windows\System32\startnet.cmd
```

## 7. Verify packages

```cmd
Dism /Image:C:\WinPE_amd64\mount /Get-Packages | findstr /i "WinPE"
```

Expected baseline:

```text
WinPE-WMI
WinPE-NetFx
WinPE-Scripting
WinPE-PowerShell
WinPE-DismCmdlets
WinPE-StorageWMI
WinPE-SecureStartup
WinPE-SecureBootCmdlets
```

## 8. Commit image

```cmd
Dism /Unmount-Image /MountDir:C:\WinPE_amd64\mount /Commit
```

## 9. Use generated media folder

The boot files are in:

```text
C:\WinPE_amd64\media
```

Copy the contents of `media` to the FAT32 boot partition of the USB stick.

Do not commit `media`, `boot.wim`, ISO files or generated WIM files to Git.
