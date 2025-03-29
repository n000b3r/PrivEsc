using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Configuration.Install;

namespace InstallUtil_custom_exe
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
        //Put DLLImports here
        
        //End of DLLImports
        
        public override void Uninstall(System.Collections.IDictionary savedState)
        {
         //Put custom code here

         //End of custom code
        }
    }
}

