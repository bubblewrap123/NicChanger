$FilePath = "c:\tools\Network_Interface.csv"
import-CSV $FilePath | ForEach-Object {
	$VM = $_.VM
	$OS = (Get-VMGuest -VM $VM).OSFullName
	if ($OS -like 'Microsoft*') {
		write-host "Microsoft"
		write-host $OS
		get-vm $VM|get-networkadapter|set-networkadapter -type vmxnet3
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