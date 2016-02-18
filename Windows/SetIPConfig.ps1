#    /*******************************************************
#    * SetIPConfig.ps1 -- Applied on boot once              *
#    *                                                      *
#    * Author:  Fredrik, Treimo                             *
#    *                                                      *
#    * Purpose: Configures the VMXNET3 adapter with -       *
#    *          the NIC-config stored in IpConfig.csv       *
#    * Usage:                                               *
#    *      Intended to be run as a scheduled task          *
#    ********************************************************/

$computername = $env:computername
$FilePath = "c:\$computername\IpSettings.csv"
$FolderPath = "c:\$computername\"
if ($(Test-Path $FilePath) -eq $TRUE) {
	$index = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').index
	$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "Index = $index"
	$wmiDescription = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').Description

	if ($wmiDescription -like "Intel(R)*") {
		write-host "E1000"
		write-host $wmiDescription
		"E1000, skipping" | Out-File -FilePath "$FolderPath\NIC_IS_E1000.txt"
	}
	Elseif ($wmiDescription -like "vmxnet3*") {
		Import-CSV $FilePath | ForEach-Object {
			$IP = $_.IP
			$MASK = $_.MASK
			$GW = $_.GW
			$MAC = $_.MAC
			$MAC_Status
			$DHCP = $_.DHCP
			#Checking if DNS2 is set, if exist combining DNS1 and DNS2 into DNS3
			if ($_.DNS2) {
				$DNS3 = $_.DNS1,$_.DNS2
				}
			else {
				$DNS3 = $_.DNS1
			}
			if ($MAC -eq $wmi.MACAddress) {
				$MAC_Status = "OK"
				write-host "MAC OK"
			}
			else {
				$MAC_Status = "NOT EQUAL"
				write-host "MAC NOT OK"
			}
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
		write-host "ERROR: Undefined NIC, exiting"
	}
}
else {
	write-host "FAILED: Could not find file: IpSettings.csv" #| Out-File -FilePath "$FolderPath\FAIL.txt"
}
