$FilePath = "c:\tools\Network_Interface.csv"
$FilePathOutput = "c:\tools\Network_Interface_Sorted.csv"

import-CSV $FilePath | ForEach-Object {
	$VM = $_.VM
	$OS = (Get-VMGuest -VM $VM).OSFullName
	$VMPowerstate = (get-vm $VM).powerstate
	if ($OS -like 'Microsoft*') {
		write-host $OS
		write-host $VMPowerstate
		"VM,Powerstate" -join ',' | Out-File -FilePath $FilePathOutput -Append -Width 200;
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

