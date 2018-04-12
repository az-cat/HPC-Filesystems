Table of Contents
=================

* [Deployment steps](#deployment-steps)
  * [Deploy the BeeGFS Master](#deploy-the-BeeGFS-master)
  * [Deploy BeeGFS Server](#deploy-BeeGFS-server)
  




## Deploy BeeGFS Master

You have to provide these parameters to the template :
* _Location_ : Select the location. 
* _Vmss Name_ : Enter the virtual machine name.
* _Node_Count_ : Enter the node count.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _SSH Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'

## Deploy BeeGFS Master(SSD)
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FBeeGFS%2Fbeegfs-master.json)  


## Deploy BeeGFS Master(HDD)
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FBeeGFS%2Fbeegfs-master-hdd.json)  


## Deploy BeeGFS OSS, MDS and Client

You have to provide these parameters to the template :
* _Location_ : Select the location. 
* _Vmss Name_ : Enter the virtual machine name.
* _Node_Count_ : Enter the node count.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _SSH Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'
* _Storage Disks Size_ : Select the disks size from the dropdown.
* _Storage Disks Count_ : Enter the disks count.
* _Meta Disks Size_ : Select the disks size from the dropdown.
* _Meta Disks Count_ : Enter the disks count.
* _Volume Type_ : Select the volume type from dropdown.
* _R Gvnet Name_ : Enter Vnet RG name.
* _Master Name_ : Enter the name of managment node.

## Deploy BeeGFS OSS, MDS and Client
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FBeeGFS%2Fdeploy-beegfs.json)  


## Deploy BeeGFS OSS, MDS and Client(HDD)
[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FBeeGFS%2Fdeploy-beegfs-hdd.json)  

## Deploy Using Azure Cli

To deploy the template using azure cli we have to use below steps-

* Download the parameters file (beegfs-master-parameters.json, deploy-beegfs-parameters.json) on local machin .
* Edit the parameters file, provide all the parameters.
* To deploy gluster server and client use below command-
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/mastercopy/BeeGFS/beegfs-master.json --parameters beegfs-master-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/mastercopy/BeeGFS/deploy-beegfs.json --parameters deploy-beegfs-parameters.json

  Note - To deploy the HDD template same parameter file can be use.

### Check your deployment
Once the deployment succeed, login to the master vm and run beegfs-check-servers command

* Templates contain maximum available VM sizes however availability of VMs depends on the data center. Not all VM sizes are available in every data center.
* Templates do not have a check to match number of disks supported by a VM. Please make sure to input correct number of disks which is supported by the VM selected for deployment.
* There are few scripts that exist in "/home/username/Scripts" (username is the user created at the time of deployment.)
	* Provide permission to scripts with sudo chmod +x <scriptname>
	* Execute a script with "sudo bash <scriptname>"
	* Install azure CLI using script install_azureCLI.sh as scripts making updates on azure will require azure CLI for execution.
	* Get a list of nodes in BeeGFS cluster. The list is an output of beegfs-check-servers command. Script name is BeeGFSListNode.sh, no parameters are required.
	* Resize a VM and increase/decrease capacity of a scale set. Script name is changesize.sh. Please go through a document available inside "Scripts/ResizeVMinScaleSet".
	* Start/stop/restart a virtual machine scale set. Script name is vmss.sh. Syntax: sudo bash ./vmss.sh <resourcegroup> <vmss name> <action (start/deallocate/stop)>
* In BeeGFS cluster only master node has public IP which can be used to connect to it. To know private IP addresses of other nodes run following commands on master node:
	* beegfs-ctl --listnodes --nodetype=meta --nicdetails - To get details about meta nodes.
	* beegfs-ctl --listnodes --nodetype=storage --nicdetails - To get details about storage nodes.

### HA implementation in BeeGFS.
To implement HA in BeeGFS run all the commands given below from any client node. 
Setup of HA on file content and meta data
1.	steps required- automatic
 for storage-
 * To create mirrorgroup for storage use command given below

	 sudo beegfs-ctl --addmirrorgroup --automatic --nodetype=storage	
 * Check list of mirror group of storage

	 beegfs-ctl --listmirrorgroups --nodetype=storage
	
 * Setup buddy mirroring on storage using command given below-

	beegfs-ctl --setpattern --numtargets=4 --chunksize=512k --buddymirror /share/scratch	

 for metadata
 * Create mirror group using command given below-

	sudo beegfs-ctl --addmirrorgroup --automatic --nodetype=meta
 * Setup buddy mirroring on metadata using command given below-

    beegfs-ctl --mirrormd




	




	

