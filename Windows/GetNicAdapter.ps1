$wmiDescription = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').Description

if ($wmiDescription -like "Intel(R)*") {
	write-host "E1000"
	write-host $wmiDescription
}
Elseif ($wmiDescription -like "vmxnet3*") {
	write-host "vmxnet3"
	write-host $wmiDescription
}
else {
	write-host "ERROR: Undefined NIC, exiting"
}