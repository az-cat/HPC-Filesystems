 





Table of Contents
=================
* [Lustre](#Lustre)
* [Deployment steps](#deployment-steps)
  * [Deploy the Lustre MDS/MGS](#Deploy-the-Lustre-MDS/MGS)
  * [Deploy Lustre OSS](#Deploy-Lustre-OSS)
  * [Deploy Lustre Client](#Deploy-Lustre-Client)

 
# Lustre 2.9.0
The MGS stores configuration information for all the Lustre file systems in a cluster and provides this information to other Lustre components. Each Lustre target contacts the MGS to provide information, and Lustre clients contact the MGS to retrieve information.

# Deployment steps
To setup Lustre three steps need to be executed :
1. Deploy the Lustre MDS/MGS
2. Deploy the Lustre OSS
3. Deploy the Lustre Client

## Deploy the Lustre MDS/MGS
Metadata servers (MDS) manage the names and directories in the file system and d.	Management servers (MGS) works as master node for the whole setup and contains the information about all the nodes attached within the cluster. 

You have to provide these parameters to the template :
* _Location_ : Select the location. 
* _Virtual Machine Name_ : Enter the virtual machine name. 
* _Virtual Machine Size_ : Select virtual machine size from the dropdown.
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _Admin Public Key_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'

## Deploy Lustre MDS/MGS
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustre%2Flustre-master.json) 
## Deploy the Lustre OSS
Data in the Lustre filesystem is stored and retrieved by two components: the Object Storage Server (OSS, a server node) and the Object Storage Target (OST, the HDD/SSD that stores the data). Together, the OSS and OST provide the data to the Client.

A Lustre filesystem can have one or more OSS nodes. An OSS typically has between two and eight OSTs attached. To increase the storage capacity of the Lustre filesystem, additional OSTs can be attached. To increase the bandwidth of the Lustre filesystem, additional OSS can be attached.
## Provision the OSS nodes
We used VM of size DS14_V2 and implemented RAID0 for all attached 10 additional data disks of 1 TB each.
You have to provide these parameters to the template :
* _Location_ : Select the same location where MDS/MGS is deployed.
* _Virtual Machine Name Prefix_ : Provide a name for prefix of VMs.
* _Node Count_ : Provide node count as per requirment.
* _Virtual Machine Size_ : Select from dropdown (Standard_DS14_v2 is recommended).
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Admin Public Key_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.
* _Storage Disk Size_ : select from the dropdown.
* _Storage Disk Count_ : Provide the no. of storage disk as per requirement.
* _RGVnet Name_ : The name of the Resource Group used to deploy the Master VM and the VNET.
* _Mgs Node Name_: Provide the same name of MGS/MDS node .


## Deploy Lustre OSS
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustre%2Flustre-storage.json)

## Deploy the Lustre Client
A Client in the Lustre filesystem is a machine that requires data. This could be a computation, visualization, or desktop node. Once mounted, a Client experiences the Lustre filesystem as if the filesystem were a local or NFS mount.
## Provision the Client nodes

You have to provide these parameters to the template :
* _Location_ : Select the same location where MDS/MGS is deployed.
* _Virtual Machine Name Prefix_ : Provide a name for prefix of VMs.
* _Node Count_ : Provide node count as per requirment.
* _Virtual Machine Size_ : Select from dropdown (Standard_DS14_v2 is recommended).
* _Admin User Name_ : This is the name of the administrator account to create on the VM.
* _Admin Public Key_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'.
* _RGVnet Name_ : The name of the Resource Group used to deploy the Master VM and the VNET.
* _Mgs Node Name_: Provide the same name of MGS/MDS node.

## Deploy Lustre Client
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustre%2Flustre-client.json)

## Deploy using azure cli

To deploy the template using azure cli we have to use below steps-

* Download the parameters file (lustre-master-parameters.json, lustre-storage-parameters.json and lustre-client-parameters.json) on local machin . 
* Edit the parameters file, provide all the parameters.
* To deploy lustre managment, servers and client use below command-
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/Lustre/lustre-master.json --parameters @lustre-master-parameters.json 
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/Lustre/lustre-storage.json --parameters @lustre-storage-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/Lustre/lustre-client.json --parameters @lustre-client-parameters.json







