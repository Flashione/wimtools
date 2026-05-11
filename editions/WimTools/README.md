# WimTools Edition

This edition contains both workflows:

```text
WimApply    Apply a WIM image to a target disk
WimCapture  Capture a Windows installation into a WIM image
```

Copy the **contents** of this folder to the NTFS data partition root.

Expected NTFS layout after copying:

```text
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\apply\apply.cmd
\WimTools\capture\capture.cmd
\Images\
\Captures\
\Logs\
```

Do not copy this edition to the FAT32 boot partition.
