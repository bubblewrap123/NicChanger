# NicChanger
Changes NICs from E1000 to VMXNET3 whitout losing in OS IP settings.

# Intent
The purpose of this project is to create a easy method of automaticly change network adapter type from E1000 to VMXNET3 on VMware VMs. This without losing the current in OS IP configuration. Since the IP settings is bound to a spesific network adapter inside Windows, configuration like IP, Gateway, Subnet, DNS etc is lost upon NIC adapter change in VMware.

# How it works
Comming soon..

#Status
The in OS windows scripts are pretty much done. I just need to add some logic if a VM has more than one active NIC with IP configuration set.

The powerCLI scrips for sorting out compatable VMs are also working. The one which does the NIC adapter type change needs some more work.
