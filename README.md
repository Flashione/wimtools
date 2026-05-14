# WimTools

WimTools is a Windows PE based toolkit for Windows image restore, capture, driver handling and USB stick preparation.

The design is intentionally simple:

```text
boot.wim
└── Windows\System32\startnet.cmd
    └── searches all drive letters for \WimTools\WIMTOOLS.TAG
        └── calls \WimTools\startup.cmd from the detected USB data partition
```

The actual WimTools scripts are not embedded into `boot.wim`. They stay on the external writable USB data partition. This keeps the PE image reusable and avoids rebuilding `boot.wim` whenever a script changes.

Important:

```text
X: is the WinPE RAM drive.
WimTools does not live on X:.
USB drive letters are not stable in WinPE.
The marker file is used to find the correct USB data partition.
```

## Microsoft requirements

Install the official Microsoft tools on the build machine:

```text
Windows ADK:
https://go.microsoft.com/fwlink/?linkid=2337875

Windows PE Add-on:
https://go.microsoft.com/fwlink/?linkid=2337681
```

Required ADK feature:

```text
Deployment Tools
```

The Windows PE Add-on is required because WinPE is not included directly in the ADK installer.

## WinPE optional components

The WimTools PE was built with these WinPE optional components:

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

See `WindowsPE\README.md` for the complete WinPE build guide.

## Repository folders

```text
WindowsPE\                   WinPE build guide and startnet.cmd template
WimTools\                    Full internal WimTools toolkit
WimTools-Restore\            Simplified restore-only package
```

## USB layout

Recommended USB layout:

```text
BOOT      FAT32   2 GB   Windows PE boot files
WIMTOOLS  NTFS    Rest   WimTools tools, images, captures, drivers and logs
```

FAT32 boot partition:

```text
\EFI\
\boot\
\sources\boot.wim
\bootmgr
\bootmgr.efi
```

NTFS data partition:

```text
\WimTools\
\Images\
\Captures\
\Logs\
```

The `WimTools` folder must contain:

```text
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
```

`WIMTOOLS.TAG` can be empty. The content is ignored. The file only has to exist.

## WinPE startup chain

```text
USB boot
-> boot.wim starts WinPE
-> X:\Windows\System32\startnet.cmd runs
-> wpeinit initializes WinPE
-> startnet.cmd searches C: through Z: for \WimTools\WIMTOOLS.TAG
-> matching drive becomes USBROOT
-> startnet.cmd calls %USBROOT%\WimTools\startup.cmd
-> startup.cmd uses %~dp0 to locate its own WimTools directory
```

This is why no hardcoded USB drive letter is used.

## Internal WimTools version

The full internal `WimTools` version contains restore, capture, driver tools and stick creation helpers.

Typical structure:

```text
WimTools\
├── WIMTOOLS.TAG
├── startup.cmd
├── common\
│   └── set-power.cmd
├── Restore\
│   ├── WimApply.cmd
│   └── Images\
├── Capture\
│   └── WimCapture.cmd
├── drivers\
│   ├── export-drivers.cmd
│   └── import-drivers.cmd
└── StickCreator\
    └── Create-WimTools-USB.cmd
```

## Restore Only version

The restore-only package is located in:

```text
WimTools-Restore\
```

For the final restore USB, the customer-facing folder on the NTFS partition must still be named:

```text
WimTools\
```

Minimal restore-only structure on the USB stick:

```text
WimTools\
├── WIMTOOLS.TAG
├── startup.cmd
└── Recovery.wim
```

`Recovery.wim` is the image file used by the restore-only script. If the repository contains only a placeholder, replace it with the real image before preparing the restore USB stick.

## Generated files policy

Do not commit generated Microsoft or image artifacts:

```text
*.wim
*.esd
*.iso
*.cab
*.msi
C:\WinPE_amd64\
WinPE media folders
WinPE mount folders
ADK installers
PE Add-on installers
```

Use documentation and scripts in the repository. Build generated PE media locally from official Microsoft sources.

## Warning

The restore and USB creation scripts erase the selected disk. Always check the disk number before confirming.
