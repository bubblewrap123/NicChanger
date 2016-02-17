#    /*******************************************************
#    * Get-VMOSPS.ps1 -- Started from Get-VMs.ps1           *
#    *                                                      *
#    * Author:  Fredrik, Treimo                             *
#    *                                                      *
#    * Purpose:  Sorting VMs into VM name & powerstate      *
#    *                                                      *
#    * Usage:                                               *
#    *      This script is intended to be run with powerCLI *
#    ********************************************************/

$FilePath = "c:\tools\Network_Interface.csv"
$FilePathOutput = "c:\tools\Network_Interface_Sorted.csv"

#Header in output file
"VM,Powerstate" -join ',' | Out-File -FilePath $FilePathOutput -Width 200;

import-CSV $FilePath | ForEach-Object {
	$VM = $_.VM
	$OS = (Get-VMGuest -VM $VM).OSFullName
	$VMPowerstate = (get-vm $VM).powerstate
	if ($OS -like 'Microsoft*') {
		write-host $OS
		write-host $VMPowerstate
		$VM,$VMPowerstate -join ',' | Out-File -FilePath $FilePathOutput -Append -Width 200;
	}
	elseif ($OS -like 'Red Hat*'){
		write-host "Linux"
		write-host $OS
	}
	else {
		if ($OS) {
			write-host "Unidentified"
			write-host $OS
		}
		else {
		write-host "Unidentified"
		write-host "Could not retrieve the specific OS type"
		}
	}
}

