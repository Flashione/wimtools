# WinPE build notes

This folder documents how the Windows PE environment for WimTools was created.

The PE image itself is intentionally kept small. It only boots Windows PE, runs `wpeinit`, searches for a USB volume containing `\WimTools\WIMTOOLS.TAG`, and then starts `\WimTools\startup.cmd` from that volume.

The actual restore, capture, driver and USB creator scripts are not embedded into the PE image. They stay on the USB stick inside the `WimTools` folder so they can be changed without rebuilding the PE image.

## Required Microsoft components

Install these Microsoft tools on the build machine:

- Windows ADK
- Windows PE add-on for the Windows ADK

Use the Deployment and Imaging Tools Environment as Administrator.

## Create the WinPE working directory

```bat
copype amd64 C:\WinPE_amd64
```

## Edit startnet.cmd

Edit this file inside the WinPE mount/work directory:

```text
C:\WinPE_amd64\media\Windows\System32\startnet.cmd
```

Use the `startnet.cmd` template documented in this folder.

The important behavior is:

```text
1. Run wpeinit
2. Set high performance power profile
3. Search drives C: through Z: for \WimTools\WIMTOOLS.TAG
4. Start \WimTools\startup.cmd from the detected USB drive
5. Keep a command prompt open if something fails
```

## Build ISO

```bat
MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE.iso
```

## USB layout

The WimTools USB stick uses two partitions:

```text
BOOT      FAT32   2 GB   Windows PE boot files
WIMTOOLS  NTFS    Rest   WimTools folder, images, drivers and scripts
```

The PE boot files are copied to the FAT32 partition.

The `WimTools` folder is copied to the NTFS partition.

## Required WimTools marker

The PE loader searches for this marker file:

```text
\WimTools\WIMTOOLS.TAG
```

The file content is ignored. The file only has to exist.
