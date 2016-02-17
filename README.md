# NicChanger
Changes NICs from E1000 to VMXNET3 whitout losing in OS IP settings.

# Intent
The purpose of this project is to create a easy method of automaticly change network adapter type from E1000 to VMXNET3 on VMware VMs. This without losing the current in OS IP configuration. Since the IP settings is bound to a spesific network adapter inside Windows, configuration like IP, Gateway, Subnet, DNS etc is lost upon NIC adapter change in VMware.

# How it works
