# NicChanger
Change network adapter from E1000 to VMXNET3 whitout losing Windows IP adapter settings.

# Tested on
+ Windows Server 2008 & R2
+ Windows Server 2012 & R2

# Intent
The purpose of this project is to create a easy method of automaticly change network adapter type from E1000 to VMXNET3 on VMware VMs. This without losing the current Windows IP configuration. Since the IP settings is bound to a spesific network adapter inside Windows, configuration like IP, Gateway, Subnet, DNS etc is lost upon NIC adapter change in VMware.

# How it works
Read the [PDF documentation](https://github.com/fredrik444/NicChanger/blob/master/Setup_NicChanger.pdf) on how to do the initial setup and how to use it.
