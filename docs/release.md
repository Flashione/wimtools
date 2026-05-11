# Release Notes and Packaging

This repository should not contain generated WinPE artifacts.

Do not commit:

```text
*.wim
*.iso
*.esd
*.swm
media/
mount/
WinPE_*/
```

## Preferred release model

The preferred model is documentation-first:

1. Clone repository.
2. Install Microsoft ADK.
3. Install Microsoft Windows PE Add-on.
4. Build WinPE locally.
5. Copy `media` contents to the FAT32 boot partition.
6. Copy `WimTools` to the NTFS data partition.

## Optional internal package

If an internal customer package is required, package it outside the Git repository.

Suggested package layout:

```text
WimToolsPE-v0.1.0.zip
└── WimToolsPE-v0.1.0\
    ├── README.txt
    ├── PEBOOT\
    │   ├── EFI\
    │   ├── boot\
    │   └── sources\
    │       └── boot.wim
    └── WIMDATA\
        ├── WimTools\
        ├── Images\
        ├── Captures\
        └── Logs\
```

If this package is distributed, check distribution requirements for Microsoft WinPE components first. The cleanest public model is to document how to build the PE from Microsoft sources instead of redistributing a prepared image.

## Hashing packages

Create SHA256 hash on Windows:

```cmd
certutil -hashfile WimToolsPE-v0.1.0.zip SHA256
```

On Linux:

```bash
sha256sum WimToolsPE-v0.1.0.zip
```
