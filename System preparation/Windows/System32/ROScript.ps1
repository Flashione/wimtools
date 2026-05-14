# ************************************
# * Change Computername              *
# ************************************
# Generate the new computer name
$newComputerName = "OEM-$(Get-Random -Minimum 1000 -Maximum 9999)"
# Get the current computer name
$currentComputerName = (Get-WmiObject -Class Win32_ComputerSystem).Name
# Rename the computer
Rename-Computer -NewName $newComputerName -Force -PassThru

# ************************************
# * Auto-Logon                       *
# ************************************
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonSID /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultDomainName /t REG_SZ /d $newComputerName /f

# *************************************
# * Delete unwanted files and folders *
# *************************************
Remove-Item -LiteralPath "c:\temp" -Force -Recurse

# ************************************
# * Restart                          *
# ************************************
shutdown -r -t 0
