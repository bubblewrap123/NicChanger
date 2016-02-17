#######################################################################
######	This script is intended to be run as a scheduled task	#######
######	It stores the active NIC IP config to file.				#######
######	After this is done, you can safely run Change-NIC.ps1	#######
######	Author Fredrik Treimo.									#######
#######################################################################

$computername = $env:computername
$FilePath = "c:\$computername\IpSettings.csv"
$FolderPath = "c:\$computername\"

If ($(Test-Path $FilePath) -eq $FALSE) { #Lager info kun hvis fil ikke eksiterer
	#Fetching the active NIC IP settings
	$index = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').index
	$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "Index = $index"
	
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
	#write-host "file exist, skipping"
	#Do nothing
}

#$(Test-Connection 10.178.127.42 -quiet)