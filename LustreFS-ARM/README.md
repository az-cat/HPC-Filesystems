# LustreFS-ARM
Template to setup LustreFS on VMSS

Table of Contents
=================
* [Lustre](#Lustre)
* [Deployment steps](#deployment-steps)
  * [Deploy the Lustre MDS/MGS](#Deploy-the-Lustre-MDS/MGS)
  * [Deploy the Lustre Jumpbox](#Deploy-the-Lustre-Jumpbox)
  * [Deploy Lustre OSS](#Deploy-Lustre-OSS)
  * [Deploy Lustre Client](#Deploy-Lustre-Client)
  * [Deploy Using Azure cli](#Deploy-Using-Azure-Cli)


 
# Lustre 2.9.0
Lustre is currently the most widely used open source parallel file system in HPC solutions. Lustre file systems can scale to tens of thousands of client nodes, tens of petabytes of storage. Lustre file system performed well for large file system, you can refer the testing results for the same.



Note- Before setup Lustre FS make sure you have service principal (id, secrete and tenant id) to get artifacts from Azure.
# Deployment steps
To setup Lustre three steps need to be executed :
1. Deploy the Lustre MDS/MGS
2. Deploy the Lustre OSS
3. Deploy the jumpbox
4. Deploy the Lustre Client

Note - We have to deploy managment, jumpbox, server and client sequencially.

## Deploy the Lustre MDS/MGS
The MGS stores configuration information for all the Lustre file systems in a cluster and provides this information to other Lustre components. Each Lustre target contacts the MGS to provide information, and Lustre clients contact the MGS to retrieve information.

You have to provide these parameters to the template :

* _Location_ : Select the location.
* _Vmss Name_ : Provide a name for prefix of VMs.
* _Node Count_ : Provide node count as per requirment.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Ssh Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.
* _Storage Disk Size_ : select from the dropdown.
* _Storage Disk Count_ : Provide the no. of storage disk as per requirement.

## Deploy Lustre MDS/MGS
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustreFS-ARM%2Flustre-master.json) 
## Deploy the Lustre Jumpbox

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
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Ssh Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.
* _Storage Disk Size_ : select from the dropdown.
* _Storage Disk Count_ : Provide the no. of storage disk as per requirement.

## Deploy Lustre Jumpbox
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustreFS-ARM%2Flustre-jumpbox.json) 

## Deploy the Lustre OSS
Data in the Lustre filesystem is stored and retrieved by two components: the Object Storage Server (OSS, a server node) and the Object Storage Target (OST, the HDD/SSD that stores the data). Together, the OSS and OST provide the data to the Client.

A Lustre filesystem can have one or more OSS nodes. An OSS typically has between two and eight OSTs attached. To increase the storage capacity of the Lustre filesystem, additional OSTs can be attached. To increase the bandwidth of the Lustre filesystem, additional OSS can be attached.
## Provision the OSS nodes
We used VM of size DS14_V2 and implemented RAID0 for all attached 10 additional data disks of 1 TB each.

You have to provide these parameters to the template :


* _Location_ : Select the location. 
* _Vmss Name_ : Enter the virtual machine name. 
* _Node_Count : Provide node count as per requirment.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Client Id_ : Enter the created client id.
* _Client secret_ : Enter the created client secret.
* _Tenant Id_ : Enter the Tenant id.
* _managmnet Node Name _ : Enter the host name of MGS/MDS node.
* _Jumpbox Name _ : Enter the host name of jumpbox.
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
* _managment Name_: Provide the same name of MGS/MDS node .
* _Jumpbox Name _ : Enter the host name of jumpbox.
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Ssh Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.


## Deploy Lustre Client
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustreFS-ARM%2Flustre-client.json)

## Deploy using azure cli

To deploy the template using azure cli we have to use below steps-

* Download the parameters file (lustre-master-parameters.json, lustre-jumpbox-parameters.json, lustre-server-parameters.json and lustre-client-parameters.json) on local machin . 
* Edit the parameters file, provide all the parameters.
* To deploy Lustre managment, jumpbox, server and client use below command-
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/LustreFS-ARM/lustre-master.json --parameters @lustre-master-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/LustreFS-ARM/lustre-jumpbox.json --parameters @lustre-jumpbox-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/LustreFS-ARM/lustre-server.json --parameters @lustre-server-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/LustreFS-ARM/lustre-client.json --parameters @lustre-client-parameters.json










