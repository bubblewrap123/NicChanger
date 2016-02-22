#    /*******************************************************
#    * Change-NIC.ps1 -- Uses data from Get-OSandPowerstate *
#    *                                                      *
#    * Author:  Fredrik, T                                  *
#    *                                                      *
#    * Purpose: Changes  NICs from E1000 to VMXNET3         *
#    *                                                      *
#    * Usage:                                               *
#    *      This script is intended to be run with powerCLI *
#    ********************************************************/

$FilePath = "c:\tools\Network_Interface_Sorted.csv"

Function pause ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

write-host "DISCLAIMER: USE THIS SCRIPT AT YOUR OWN RISK!"
write-host "THE AUTHOR TAKES NO RESPONSIBILITY FOR THE RESULTS OF THIS SCRIPT."
write-host "Disclaimer aside, this worked for the author, for what that's worth."
pause "Press any key to continue"


import-CSV $FilePath | ForEach-Object {
	$VM = $_.VM
	$VMPowerstate = $_.Powerstate
	
	if ($VMPowerstate -eq "PoweredOff") { #We don't want to change network adapter on a VMs which has not run the GetIPConfig.ps1.
		#get-vm $VM|get-networkadapter|set-networkadapter -type vmxnet3 -Confirm:$false
		#write-host "Nic changed on:" $VM
		#Start-VM $VM #-RunAsync
		#write-host $VM "started"
	}
	elseif ($VMPowerstate -eq "PoweredOn") { 
		Shutdown-VMGuest $VM -Confirm:$false #We need to check if the guest OS is shut down before proceeding..
		while (((get-vm $VM).powerstate) -eq "PoweredOn") {
			 start-sleep 10
		}
		get-vm $VM|get-networkadapter|set-networkadapter -type vmxnet3 -Confirm:$false
		start-sleep 10
		Start-VM $VM
	}
	else {
	Write-host $VM " in unknown state, let's not try to change the NIC on this VM.."
	}
}
