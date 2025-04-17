function Convert-IPv4ToUInt32 {
    param([string]$IP)
    $bytes = [System.Net.IPAddress]::Parse($IP).GetAddressBytes()
    [Array]::Reverse($bytes)
    return [BitConverter]::ToUInt32($bytes, 0)
}
function Convert-UInt32ToIPv4 {
    param([uint32]$Int)
    $bytes = [BitConverter]::GetBytes($Int)
    [Array]::Reverse($bytes)
    return ([System.Net.IPAddress]::new($bytes)).ToString()
}
function Get-UsableRange {
    param([uint32]$IPInt, [int]$Prefix)
    if ($Prefix -eq 0) {
        $mask = [uint32]0
    } else {
        $bitsOn  = [math]::Pow(2, $Prefix) - 1
        $mask    = [uint32]($bitsOn * [math]::Pow(2, 32 - $Prefix))
    }
    $network   = $IPInt -band $mask
    $size      = [uint32][math]::Pow(2, 32 - $Prefix)
    $broadcast = $network + $size - 1
    return [PSCustomObject]@{ Start = $network + 1; End = $broadcast - 1 }
}

# 1) Gather your IPv4 interfaces
$adapters = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.PrefixOrigin -ne 'WellKnown' -and
        $_.IPAddress       -notlike '169.254.*' -and
        $_.IPAddress       -ne '127.0.0.1'
    }

# 2) Compute networks
$networks = $adapters | ForEach-Object {
    $ip     = $_.IPAddress
    $pref   = $_.PrefixLength
    $ipInt  = Convert-IPv4ToUInt32 $ip
    $range  = Get-UsableRange -IPInt $ipInt -Prefix $pref

    if ($pref -eq 0) {
        $mask = [uint32]0
    } else {
        $bitsOn  = [math]::Pow(2, $pref) - 1
        $mask    = [uint32]($bitsOn * [math]::Pow(2, 32 - $pref))
    }
    $networkInt = $ipInt -band $mask

    [PSCustomObject]@{
        NetworkInt = $networkInt
        Prefix     = $pref
        Range      = $range
    }
} | Sort-Object NetworkInt, Prefix -Unique

# 3) Ping-sweep using System.Net.NetworkInformation.Ping
$results = foreach ($net in $networks) {
    $start = $net.Range.Start
    $end   = $net.Range.End
    if ($start -gt $end) { continue }

    for ($addr = $start; $addr -le $end; $addr++) {
        $ip = Convert-UInt32ToIPv4 $addr

        # Use .NET Ping with 1 000 ms timeout
        $ping = New-Object System.Net.NetworkInformation.Ping
        $reply = $ping.Send($ip, 1000)
        if ($reply.Status -eq 'Success') {
            try {
                $hostEntry = [System.Net.Dns]::GetHostEntry($ip)
                $fqdn      = $hostEntry.HostName
                $name      = $fqdn.Split('.')[0]
            } catch {
                $fqdn = $ip
                $name = $ip
            }
            [PSCustomObject]@{
                IP       = $ip
                FQDN     = $fqdn
                HostName = $name
            }
        }
    }
}

# 4) Emit /etc/hosts lines, sorted by IP
$results |
  Sort-Object { Convert-IPv4ToUInt32 $_.IP } |
  ForEach-Object {
    "{0,-15} {1,-30} {2}" -f $_.IP, $_.FQDN, $_.HostName
  }

