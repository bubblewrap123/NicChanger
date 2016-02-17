#    /*******************************************************
#    * GetIPConfig.ps1 -- Applied as scheduled task         *
#    *                                                      *
#    * Author:  Fredrik, Treimo                             *
#    *                                                      *
#    * Purpose: Stores the E1000 NIC config to file -       *
#    *          IpConfig.csv                                *
#    * Usage:                                               *
#    *      Intended to be run as a scheduled task          *
#    ********************************************************/

$computername = $env:computername
$FilePath = "c:\$computername\IpSettings.csv"
$FolderPath = "c:\$computername\"

If ($(Test-Path $FilePath) -eq $FALSE) { #Stores NIC IP settings if config file does not already exist.
	#Fetching the active NIC IP settings
	$index = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').index
	$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "Index = $index"
	$wmiDescription = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').Description
	
	#Store settings only if adapter equals E1000
	if ($wmiDescription -like "Intel(R)*") {
		#Is DHCP enabled?
		$DHCP = $wmi.DHCPEnabled
		#Does folder already exist?
		if ($(Test-Path $FolderPath) -eq $FALSE) { 
			New-Item $FolderPath -type directory
			}
		else {
		#Don't do anything
		}
		$IP = $wmi.IPAddress[0]
		$MASK = $wmi.IPSubnet[0]
		$GW = $wmi.DefaultIPGateway[0]
		$MAC = $wmi.MACAddress
		$DNS1 = $wmi.DNSServerSearchOrder[0]
		$DNS2 = $wmi.DNSServerSearchOrder[1]
		#Saves IP settings to file
		"IP,MASK,GW,DNS1,DNS2,DHCP,MAC" -join ',' | Out-File -FilePath $FilePath -Width 200;
		$IP,$MASK,$GW,$DNS1,$DNS2,$DHCP,$MAC -join ',' | Out-File -FilePath $FilePath -Append -Width 200;
	}
	else {
	#Do nothing
	}
}
else {
	#write-host "file exist, skipping"
	#Do nothing
}

