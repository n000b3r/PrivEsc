# add_to_sysadmin.ps1  (PS 5.1 compatible)
# Optional: $env:ADD_SQLADMIN_USER = "HOST\bill" or "DOMAIN\bill"

$ErrorActionPreference = 'Stop'
function Out-Line($m){Write-Output "[add_to_sysadmin] $m"}

# Target user
$TargetUser = $env:ADD_SQLADMIN_USER
if ([string]::IsNullOrWhiteSpace($TargetUser)) { $TargetUser = "$env:COMPUTERNAME\bill" }
Out-Line "Target user: $TargetUser"

# sqlcmd required
if (-not (Get-Command sqlcmd -ErrorAction SilentlyContinue)) { Out-Line "sqlcmd not found."; return }

# Find SQL engine service
$svc = Get-Service | Where-Object { $_.DisplayName -like 'SQL Server (*' } | Select-Object -First 1
if (-not $svc) { $svc = Get-Service | Where-Object { $_.DisplayName -eq 'SQL Server' } | Select-Object -First 1 }
if (-not $svc) { Out-Line "No SQL Server engine service found."; return }

$engineName = $svc.Name
$instance = 'MSSQLSERVER'
if ($svc.DisplayName -match '\(([^)]+)\)') { $instance = $Matches[1] }

# Build connection target (no ternary)
$ConnTarget = 'localhost'
if ($instance -ne 'MSSQLSERVER') { $ConnTarget = "localhost\$instance" }

# Agent may not exist; may be stopped
$agent = Get-Service -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq "SQL Server Agent ($instance)" } | Select-Object -First 1
$agentName = $null
$agentRunning = $false
if ($agent) {
  $agentName = $agent.Name
  $agentRunning = ((Get-Service -Name $agentName).Status -eq 'Running')
}

# If target already sysadmin, exit early
$already = ''
try {
  $already = (sqlcmd -S $ConnTarget -E -h -1 -Q "SET NOCOUNT ON; SELECT IS_SRVROLEMEMBER('sysadmin', N'$TargetUser');" 2>$null).Trim()
} catch {}
if ($already -eq '1') { Out-Line "$TargetUser already has sysadmin on $ConnTarget."; return }

# Stop Agent only if running
if ($agent -and $agentRunning) {
  Out-Line "Stopping Agent $agentName"
  & net stop $agentName | Out-Null
} else {
  Out-Line "Agent not running or not present; skipping stop."
}

# Stop engine if running
if ((Get-Service -Name $engineName).Status -eq 'Running') {
  Out-Line "Stopping Engine $engineName"
  & net stop $engineName | Out-Null
}

# Start single-user restricted to SQLCMD
Out-Line "Starting Engine in single-user mode (SQLCMD only)"
& NET START $engineName /m"SQLCMD" | Out-Null

# Grant sysadmin to target user
$tsql = @"
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'$TargetUser')
    CREATE LOGIN [$TargetUser] FROM WINDOWS;
ALTER SERVER ROLE sysadmin ADD MEMBER [$TargetUser];
"@
Out-Line "Granting sysadmin to $TargetUser on $ConnTarget"
sqlcmd -S $ConnTarget -E -b -Q $tsql

# Restart normally
Out-Line "Restarting Engine normally"
& net stop $engineName | Out-Null
& net start $engineName | Out-Null
if ($agent -and $agentRunning) {
  Out-Line "Starting Agent $agentName"
  & net start $agentName | Out-Null
}

# Verify
$verify = (sqlcmd -S $ConnTarget -E -h -1 -Q "SET NOCOUNT ON; SELECT IS_SRVROLEMEMBER('sysadmin', N'$TargetUser');" 2>$null).Trim()
if ($verify -eq '1') {
  Out-Line "Success: $TargetUser is now sysadmin on $ConnTarget."
} else {
  Out-Line "Verification returned: '$verify'"
}

