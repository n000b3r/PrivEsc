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
```

## Source
https://github.com/nicocha30/ligolo-ng/releases/tag/v0.7.5
