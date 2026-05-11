# WimTools

WimTools is a simple Windows PE based toolkit for Windows image apply and capture workflows.

This repository does **not** contain a prepared WinPE image, ISO, WIM, ESD or Microsoft ADK files. WinPE must be created locally from the official Microsoft ADK and Windows PE Add-on.

## Simple idea

There are two parts:

```text
FAT32 boot partition  = WinPE boot files only
NTFS data partition   = one complete WimTools edition folder
```

`WimTools` does **not** belong on the FAT32 boot partition. It belongs on the writable NTFS data partition.

The customer-facing workflow should be this simple:

```text
1. Build or copy the WinPE boot files to the FAT32 partition.
2. Choose one edition folder.
3. Copy the contents of that edition folder to the NTFS partition root.
4. Boot the device.
```

## Editions

The repository contains three self-contained edition folders:

```text
editions/WimTools/     Apply + Capture
editions/WimApply/     Apply only
editions/WimCapture/   Capture only
```

Each edition folder is meant to be copied as-is to the NTFS data partition root.

Example for the full edition:

```text
copy contents of editions/WimTools/ to NTFS root
```

Result on the NTFS partition:

```text
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\apply\apply.cmd
\WimTools\capture\capture.cmd
\Images\
\Captures\
\Logs\
```

## WimApply scope

WimApply is intentionally rudimentary:

```text
select disk
clean disk
apply WIM image
write bootloader
```

No GUI, no deployment server, no hidden automation magic. Pick a disk, wipe it, apply the image, make it boot. Astonishingly, even that needs guardrails, because Windows imaging is where optimism goes to file a complaint.

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

The current WinPE baseline uses these optional components:

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

## Startup chain

The WinPE image contains only a minimal `startnet.cmd`.

```text
boot.wim
└── Windows\System32\startnet.cmd
    ├── runs wpeinit
    ├── searches all drive letters for \WimTools\WIMTOOLS.TAG
    └── calls \WimTools\startup.cmd from the NTFS data partition
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
├── editions/
│   ├── WimTools/
│   ├── WimApply/
│   └── WimCapture/
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
