# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Error "Please run this script as Administrator!"
    exit
}

Write-Host "`n[+] Re-enabling Windows Firewall on all profiles..."
netsh advfirewall set allprofiles state on

Write-Host "`n[+] Reinstalling Windows Defender definitions..."
$defender = "C:\Program Files\Windows Defender\MpCmdRun.exe"
if (Test-Path $defender) {
    & $defender -SignatureUpdate
} else {
    Write-Warning "[-] MpCmdRun.exe not found. Skipping Defender signature restore."
}

Write-Host "`n[+] Disabling Remote Desktop (deny RDP connections)..."
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f

Write-Host "`n[+] Checking if 'bill' account exists..."
$userCheck = net user bill 2>&1
if ($userCheck -notmatch "The user name could not be found") {
    Write-Host "[+] Deleting local user 'bill'..."
    net user bill /delete
} else {
    Write-Host "[i] User 'bill' does not exist."
}

Write-Host "`n[+] Rollback completed successfully."

