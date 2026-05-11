# WimTools

WimTools is a simple Windows PE based toolkit for Windows image apply and capture workflows.

This repository does **not** contain a prepared WinPE image, ISO, WIM, ESD or Microsoft ADK files. WinPE must be created locally from the official Microsoft ADK and Windows PE Add-on.

## Versions

The same base can be packaged in three variants:

```text
WimTools    Apply + Capture
WimApply    Apply only
WimCapture  Capture only
```

## WimApply scope

WimApply is intentionally rudimentary:

```text
select disk
clean disk
apply WIM image
write bootloader
```

No GUI, no deployment server, no hidden automation magic. Pick a disk, wipe it, apply the image, make it boot. Apparently even that needs a project now, because Windows imaging exists to punish optimism.

## Official Microsoft downloads

Download the required Microsoft components here:

- Windows ADK: https://go.microsoft.com/fwlink/?linkid=2337875
- Windows PE Add-on for the ADK: https://go.microsoft.com/fwlink/?linkid=2337681

Install the Windows ADK first.

During ADK setup, install:

```text
Deployment Tools
```

After that, install the Windows PE Add-on.

## Baseline WinPE optional components

The current WimTools PE baseline uses these WinPE optional components:

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

## Startup design

The WinPE image contains only a minimal `startnet.cmd`.

Startup chain:

```text
boot.wim
└── Windows\System32\startnet.cmd
    ├── runs wpeinit
    ├── searches all drive letters for \WimTools\WIMTOOLS.TAG
    └── calls \WimTools\startup.cmd from the external writable partition
```

Scripts can be changed on the USB data partition without rebuilding `boot.wim`.

## USB layout

Use a two-partition USB stick:

```text
Partition 1: FAT32, about 2 GB
Purpose: WinPE boot files

Partition 2: NTFS, remaining space
Purpose: WimTools, images, captures and logs
```

Example layout:

```text
FAT32 boot partition:
\EFI\
\boot\
\sources\boot.wim

NTFS data partition:
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\apply\apply.cmd
\WimTools\capture\capture.cmd
\Images\
\Captures\
\Logs\
```

The marker file `\WimTools\WIMTOOLS.TAG` can be empty. It only has to exist.

## Repository structure

```text
.
├── README.md
├── pe/
│   └── startnet.cmd
├── scripts/
│   └── build-winpe.cmd
├── WimTools/
│   ├── WIMTOOLS.TAG
│   ├── startup.cmd
│   ├── common/
│   │   └── set-power.cmd
│   ├── apply/
│   │   └── apply.cmd
│   └── capture/
│       └── capture.cmd
└── docs/
    ├── winpe-build.md
    ├── usb-layout.md
    └── release.md
```

## Generated files policy

Do not commit generated Microsoft or build artifacts:

```text
*.wim
*.iso
*.esd
*.swm
*.cab
*.msi
WinPE_*/
media/
mount/
adk/
winpe/
```

## Status

Early development. WimApply is the first practical workflow target.
