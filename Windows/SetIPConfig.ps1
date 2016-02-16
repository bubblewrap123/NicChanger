$computername = $env:computername
$FilePath = "c:\$computername\IpSettings.csv"
$FolderPath = "c:\$computername\"
if ($(Test-Path $FilePath) -eq $TRUE) {
	$index = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').index
	$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "Index = $index"

	Import-CSV $FilePath | ForEach-Object {
		$IP = $_.IP
		$MASK = $_.MASK
		$GW = $_.GW
		$MAC = $_.MAC
		#Checking if DNS2 is set, if exist combining DNS1 and DNS2 into DNS3
		if ($_.DNS2) {
			$DNS3 = $_.DNS1,$_.DNS2
			}
		else {
			$DNS3 = $_.DNS1
		}
		if ($MAC -eq $wmi.MACAddress) {
			write-host "MAC OK"
		}
		else {
			write-host "MAC NOT OK"
		}
		$DHCP = $_.DHCP
		if ($DHCP -eq "False") {
			"Config:`r`n"+"IP "+$_.IP,"`r`nMASK: "+$_.MASK,"`r`nGW: "+$_.GW,"`r`nDHCP: "+$DHCP,"`r`nMAC: "+$MAC,"`r`nDNS: "+$DNS3 | Out-File -FilePath "$FolderPath\OK.txt"
			$wmi.EnableStatic($IP, $MASK)
			$wmi.SetGateways($GW, 1)
			$wmi.SetDNSServerSearchOrder($DNS3)
		}
		elseif ($DHCP -eq "True") {
			"DHCP Enabled, nothing to do here" | Out-File -FilePath "$FolderPath\OK.txt"
		}
	}
}
else {
	"FAILED: Could not find file: IpSettings.csv" | Out-File -FilePath "$FolderPath\FAIL.txt"
}