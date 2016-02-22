#    /*******************************************************
#    * Change-NIC.ps1 -- Uses data from Get-VMOSPS.ps1      *
#    *                                                      *
#    * Author:  Fredrik, Treimo                             *
#    *                                                      *
#    * Purpose: Changes  NICs from E1000 to VMXNET3         *
#    *                                                      *
#    * Usage:                                               *
#    *      This script is intended to be run with powerCLI *
#    ********************************************************/

$FilePath = "c:\tools\Network_Interface_Sorted.csv"

import-CSV $FilePath | ForEach-Object {
	$VM = $_.VM
	$VMPowerstate = $_.Powerstate
	
	if ($VMPowerstate -eq "PoweredOff") { #Må tenke litt på hva vi gjør her. Trenger vi å skru den på først, for at den skal lagre IP settings via scheduled task?
		#get-vm $VM|get-networkadapter|set-networkadapter -type vmxnet3 -Confirm:$false
		#write-host "Nic changed on:" $VM
		#Start-VM $VM #-RunAsync
		#write-host $VM "started"
	}
	elseif ($VMPowerstate -eq "PoweredOn") { 
		Shutdown-VMGuest $VM -Confirm:$false #We need to check if the guest OS is shut down before proceeding.. The next lines will fail otherwize.
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
