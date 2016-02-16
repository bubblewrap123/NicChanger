
get-networkadapter(get-vm) | where {$_.Type -eq "e1000"} | Select @{N="VM";E={$_.Parent.Name}},Type | export-Csv  c:\tools\Network_Interface.csv -NoTypeInformation
