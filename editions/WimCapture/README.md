# WimCapture Edition

This edition contains only the capture workflow.

Copy the **contents** of this folder to the NTFS data partition root.

Expected NTFS layout after copying:

```text
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\capture\capture.cmd
\Captures\
\Logs\
```

WimCapture is intentionally rudimentary:

```text
select Windows source volume
select output path
capture WIM image
write metadata and log file
```

Do not copy this edition to the FAT32 boot partition.
