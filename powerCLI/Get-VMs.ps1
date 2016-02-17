#/********************************************************           
#    * hello -- Outputs all VMs in vCenter to a file        *   
#    *                                                      *   
#    * Author:  Fredrik, Treimo                             *   
#    *                                                      *   
#    * Purpose:  outputs all VMs in vCenter to a file       *   
#    *                                                      *   
#    * Usage:                                               *   
#    *      This script is intended to be run with powerCLI *   
#    ********************************************************/ 



$FilePath = "c:\tools\Network_Interface.csv"

get-networkadapter(get-vm) | where {$_.Type -eq "e1000"} | Select @{N="VM";E={$_.Parent.Name}},Type | export-Csv  $FilePath -NoTypeInformation
write-host "All current VMs stored in " $FilePath
write-host "Starting Get-OSversion.ps1 to filter out VMs other than Windows" 
Invoke-Expression "c:\Scripts\Treimo\powerCLI\Get-OSandPowerstate.ps1"

 
