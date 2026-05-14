# WimTools

WimTools is a small Windows PE based toolkit for Windows image restore, capture and driver handling.

The PE image is intentionally minimal. It only starts Windows PE, searches for a `WimTools` folder on the USB stick, and then runs `WimTools\startup.cmd`.

The actual tools stay outside the PE image on the USB stick. This means the scripts can be changed without rebuilding the PE image, because apparently not rebuilding `boot.wim` for every tiny change is considered luxury now.

## Main folders

```text
Create-WimTools-USB.cmd      Prepare a USB stick with FAT32 + NTFS partitions
PE\                          WinPE build notes and startnet.cmd template
WindowsPE\                   Files copied to the FAT32 boot partition
WimTools\                    Full internal WimTools toolkit
Customer-Restore\            Simplified customer restore variant
```

## USB layout

The USB stick uses two partitions:

```text
BOOT      FAT32   2 GB   Windows PE boot files
WIMTOOLS  NTFS    Rest   WimTools tools, images and drivers
```

Copy the content of `WindowsPE` to the FAT32 boot partition.

Copy the `WimTools` folder to the NTFS partition.

## WinPE loader behavior

The embedded `startnet.cmd` inside WinPE searches all drive letters for:

```text
\WimTools\WIMTOOLS.TAG
```

When found, it starts:

```text
\WimTools\startup.cmd
```

The marker file content is ignored. The file only has to exist.

See `PE\README.md` for the PE creation notes and `PE\startnet.cmd` for the loader template.

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

## Customer restore version

The customer restore variant is intentionally simple:

```text
WimTools\
├── WIMTOOLS.TAG
├── startup.cmd
└── Recovery.wim
```

`Recovery.wim` is the image file used by the customer restore script. If the repository contains only a placeholder, replace it with the real customer image before preparing the customer USB stick.

## Warning

The restore and USB creation scripts erase the selected disk. Always check the disk number before confirming.
