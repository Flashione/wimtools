# WimTools

WimTools is the full internal Windows PE toolkit for image restore, image capture, driver handling and USB stick preparation.

This repository does not build Windows PE. The PE boot environment is provided by the separate `WindowsPE` repository.

## Startup model

The universal Windows PE loader searches the USB data partition for:

```text
\start.cmd
```

This repository provides that file at the repository root. The router then starts:

```text
\WimTools\startup.cmd
```

The WimTools menu itself uses `%~dp0` to locate its own directory. No fixed USB drive letter is required, because WinPE drive letters are not stable. Astonishingly, this is the sane part.

## USB runtime layout

Copy the contents of this repository to the NTFS data partition of the USB stick.

Expected NTFS layout:

```text
\start.cmd
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\common\set-power.cmd
\WimTools\Restore\WimApply.cmd
\WimTools\Restore\Images\
\WimTools\Capture\WimCapture.cmd
\WimTools\drivers\export-drivers.cmd
\WimTools\drivers\import-drivers.cmd
\WimTools\StickCreator\Create-WimTools-USB.cmd
```

The FAT32 boot partition is created from the `WindowsPE` repository output.

## Tool overview

```text
Restore       Apply a WIM image to a selected disk
Capture       Capture an existing Windows installation into a WIM image
Drivers       Offline driver export and import
StickCreator  Prepare a USB stick with BOOT and WIMTOOLS partitions
```

## Default image path

The restore and capture scripts use this default image path:

```text
\WimTools\Restore\Images\Recovery.wim
```

The folder may contain a placeholder file in the repository. Replace it with a real image when preparing a production USB stick.

## Required WindowsPE repository

Use this repository together with:

```text
WindowsPE
```

The WindowsPE repository provides:

```text
startnet.cmd
WinPE build documentation
PE boot files after local build
```

The PE loader chain is:

```text
boot.wim
-> X:\Windows\System32\startnet.cmd
-> searches all drive letters for \start.cmd
-> calls \start.cmd from the detected USB data partition
-> \start.cmd calls \WimTools\startup.cmd
```

## Generated files policy

Do not commit generated image or Microsoft installer artifacts:

```text
*.wim
*.esd
*.iso
*.cab
*.msi
ADK installers
PE Add-on installers
WinPE media folders
WinPE mount folders
```

## Warning

Restore and USB creation scripts erase the selected disk. Always verify the disk number before continuing.
