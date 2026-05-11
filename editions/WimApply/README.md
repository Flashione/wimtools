# WimApply Edition

This edition contains only the apply workflow.

Copy the **contents** of this folder to the NTFS data partition root.

Expected NTFS layout after copying:

```text
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\apply\apply.cmd
\Images\
\Logs\
```

WimApply is intentionally rudimentary:

```text
select disk
clean disk
apply WIM image
write bootloader
```

Do not copy this edition to the FAT32 boot partition.
