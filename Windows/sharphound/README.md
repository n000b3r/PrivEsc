# Name
SharpHound (To output zip file for BloodHound, AD Enum)

## Usage
```
SharpHound.exe -c all

# OR
Import-Module ..\Sharphound.ps1
Invoke-BloodHound -CollectionMethod All -OutputPrefix "corp_audit"
```

## Source
https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip
https://github.com/BloodHoundAD/BloodHound/blob/master/Collectors/SharpHound.ps1
