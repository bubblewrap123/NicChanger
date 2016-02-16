$wmi = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').Description

if ($wmi -like "Intel(R)*") {
	write-host "E1000"
	write-host $wmi
}
Elseif ($wmi -like "vmxnet3*") {
	write-host "vmxnet3"
	write-host $wmi
}
else {
	write-host "ERROR: Undefined NIC, exiting"
}