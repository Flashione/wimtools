# WimTools

WimTools is a small Windows PE based toolkit concept for Windows image apply and capture workflows.

This repository does **not** contain a prepared WinPE image, ISO, WIM, ESD or Microsoft ADK files. WinPE must be created locally from the official Microsoft ADK and Windows PE Add-on.

## Purpose

The goal is simple:

- build WinPE from official Microsoft sources
- keep `boot.wim` generic and reproducible
- keep the actual tool logic outside the WIM under `\WimTools`
- use `startnet.cmd` only as a small boot loader
- keep images, captures and logs on a writable NTFS partition

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

This gives the PE environment PowerShell, DISM cmdlets, WMI, storage tooling and Secure Boot / BitLocker related command support without turning the image into a bloated museum exhibit.

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

This means scripts can be changed on the USB data partition without rebuilding `boot.wim` every time.

## Recommended USB layout

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
\WimTools\forge\
\WimTools\vault\
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
│   ├── forge/
│   │   └── apply.cmd
│   └── vault/
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

If a ready-made package is needed for internal use, publish it as a GitHub Release asset only after checking distribution requirements. The preferred model is still: document the build, then generate the PE locally.

## Status

Early development. The repository currently documents the WinPE build, startup chain and planned apply/capture structure.
