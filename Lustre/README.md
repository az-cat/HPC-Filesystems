 





Table of Contents
=================
* [Lustre](#Lustre)
* [Deployment steps](#deployment-steps)
  * [Deploy the Lustre MDS/MGS](#Deploy-the-Lustre-MDS/MGS)
  * [Deploy Lustre OSS](#Deploy-Lustre-OSS)
  * [Deploy Lustre Client](#Deploy-Lustre-Client)

 
# Lustre
Lustre is currently the most widely used parallel file system in HPC solutions. Lustre file systems can scale to tens of thousands of client nodes, tens of petabytes of storage. Lustre file system performed well for large file system, you can refer the testing results for the same.

# Deployment steps
To setup Lustre three steps need to be executed :
1. Deploy the Lustre MDS/MGS
2. Deploy the Lustre OSS
3. Deploy the Lustre Client

## Deploy the Lustre MDS/MGS
Metadata servers (MDS) manage the names and directories in the file system and d.	Management servers (MGS) works as master node for the whole setup and contains the information about all the nodes attached within the cluster. 

You have to provide these parameters to the template :
* _Location_ : Select the location where NC series is available(for example East US,South Central US). 
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
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FLustre%2Flustre-server.json)

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





