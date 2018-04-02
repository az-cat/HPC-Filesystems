# LustreFS-ARM
Template to setup LustreFS on VMSS

Table of Contents
=================
* [Lustre](#Lustre)
* [Deployment steps](#deployment-steps)
  * [Deploy the Lustre MDS/MGS](#Deploy-the-Lustre-MDS/MGS)
  * [Deploy Lustre OSS](#Deploy-Lustre-OSS)
  * [Deploy Lustre Client](#Deploy-Lustre-Client)

 
# Lustre
Lustre is currently the most widely used parallel file system in HPC solutions. Lustre file systems can scale to tens of thousands of client nodes, tens of petabytes of storage. Lustre file system performed well for large file system, you can refer the testing results for the same.



Note- Before setup Gluster FS make sure you have service principal (id, secrete and tenant id) to get artifacts from Azure.
# Deployment steps
To setup Lustre three steps need to be executed :
1. Deploy the Lustre MDS/MGS
2. Deploy the Lustre OSS
3. Deploy the Lustre Client

## Deploy the Lustre MDS/MGS
Metadata servers (MDS) manage the names and directories in the file system and d.	Management servers (MGS) works as master node for the whole setup and contains the information about all the nodes attached within the cluster. 

You have to provide these parameters to the template :

* _Location_ : Select the same location where MDS/MGS is deployed.
* _Vmss Name_ : Provide a name for prefix of VMs.
* _Node Count_ : Provide node count as per requirment.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Mgs Node Name_: Provide the same name of MGS/MDS node .
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Ssh Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.
* _Storage Disk Size_ : select from the dropdown.
* _Storage Disk Count_ : Provide the no. of storage disk as per requirement.

## Deploy Lustre MDS/MGS
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustreFS-ARM%2Flustre-master.json) 
## Deploy the Lustre OSS
Data in the Lustre filesystem is stored and retrieved by two components: the Object Storage Server (OSS, a server node) and the Object Storage Target (OST, the HDD/SSD that stores the data). Together, the OSS and OST provide the data to the Client.

A Lustre filesystem can have one or more OSS nodes. An OSS typically has between two and eight OSTs attached. To increase the storage capacity of the Lustre filesystem, additional OSTs can be attached. To increase the bandwidth of the Lustre filesystem, additional OSS can be attached.
## Provision the OSS nodes

You have to provide these parameters to the template :


* _Location_ : Select the location where NC series is available(for example East US,South Central US). 
* _Vmss Name_ : Enter the virtual machine name. 
* _Node_Count : Enter the virtual machine name._
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Client Id_ : Enter the created client id.
* _Client secret_ : Enter the created client secret.
* _Tenant Id_ : Enter the Tenant id.
* _MGS/MDS Node Name _ : Enter the host name of MGS/MDS node.
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _Ssh Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.
* _Storage Disks Size_ : Select the disks size from the dropdown.
* _Storage Disks Count_ : Enter the disks count.










## Deploy Lustre OSS
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustreFS-ARM%2Flustre-server.json)

## Deploy the Lustre Client
A Client in the Lustre filesystem is a machine that requires data. This could be a computation, visualization, or desktop node. Once mounted, a Client experiences the Lustre filesystem as if the filesystem were a local or NFS mount.
## Provision the Client nodes

You have to provide these parameters to the template :


* _Location_ : Select the same location where MDS/MGS is deployed.
* _Vmss Name_ : Provide a name for prefix of VMs.
* _Node Count_ : Provide node count as per requirment.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Mgs Node Name_: Provide the same name of MGS/MDS node .
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Ssh Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.


## Deploy Lustre Client
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustreFS-ARM%2Flustre-client.json)











