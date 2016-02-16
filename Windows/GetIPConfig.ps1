#Kjører kun script hvis den har nett
If ($(Test-Connection 10.178.127.42 -quiet) -eq $TRUE) { #NTP server Testsenter
	#Henter IP instillinger for E1000 adapter
	$index = (Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"').index
	$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "Index = $index"

	#For ordensskyld lagrer vi variabler for maskinnavn og hvor output skal lagres
	$computername = $env:computername
	$FilePath = "c:\$computername\IpSettings.csv"
	$FolderPath = "c:\$computername\"

	#Lagrer resulatet av spørringen om dhcp er aktivert.
	$DHCP = $wmi.DHCPEnabled
	#Tester om mappen som skal bli opprettet for output eksisterer,
	#gjør den ikke det opprettes den. Finnes den fra før skippes mappeopprettelsen.
	if ($(Test-Path $FolderPath) -eq $FALSE) { 
		New-Item $FolderPath -type directory
		}
	else {
	#Skipp
	}
	$IP = $wmi.IPAddress[0]
	$MASK = $wmi.IPSubnet[0]
	$GW = $wmi.DefaultIPGateway[0]
	$MAC = $wmi.MACAddress
	$DNS1 = $wmi.DNSServerSearchOrder[0]
	$DNS2 = $wmi.DNSServerSearchOrder[1]
	#Lagrer config til fil, slik at scriptet "SetIpConfig.ps1" kan hente disse inn etter reboot.
	"IP,MASK,GW,DNS1,DNS2,DHCP,MAC" -join ',' | Out-File -FilePath $FilePath -Width 200;
	$IP,$MASK,$GW,$DNS1,$DNS2,$DHCP,$MAC -join ',' | Out-File -FilePath $FilePath -Append -Width 200;
}