# USB Layout

WimTools uses a two-partition USB layout.

## Partition 1: FAT32 boot partition

Recommended size:

```text
2 GB
```

Purpose:

```text
WinPE boot files
```

Example content:

```text
\EFI\
\boot\
\sources\boot.wim
```

The contents come from:

```text
C:\WinPE_amd64\media
```

## Partition 2: NTFS data partition

Recommended size:

```text
Remaining USB capacity
```

Purpose:

```text
WimTools scripts
Windows images
Saved images
Logs
```

Example content:

```text
\WimTools\WIMTOOLS.TAG
\WimTools\startup.cmd
\WimTools\common\set-power.cmd
\WimTools\forge\apply.cmd
\WimTools\vault\capture.cmd
\Images\
\Captures\
\Logs\
```

## Marker file

The file:

```text
\WimTools\WIMTOOLS.TAG
```

is used by `startnet.cmd` to find the correct writable partition.

The file can be empty. It only has to exist.

## Why this layout exists

WinPE boots into:

```text
X:
```

`X:` is a RAM drive created from `boot.wim`.

The USB stick itself receives normal drive letters such as:

```text
D:
E:
F:
```

These letters are not stable. That is why WimTools searches all drive letters for the marker file instead of assuming a fixed drive letter.
