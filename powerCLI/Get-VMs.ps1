$FilePath = "c:\tools\Network_Interface.csv"

get-networkadapter(get-vm) | where {$_.Type -eq "e1000"} | Select @{N="VM";E={$_.Parent.Name}},Type | export-Csv  $FilePath -NoTypeInformation
write-host "All current VMs stored in " $FilePath
write-host "Starting Get-OSversion.ps1 to filter out VMs other than Windows" 
#Invoke-Expression c:\scripts\test.ps1

 