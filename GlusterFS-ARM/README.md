

Table of Contents
=================
* [Gluster](#Gluster)
* [Deployment steps](#deployment-steps)
  * [Deploy the Gluster Server](#deploy-the-gluster-server)
  * [Deploy Gluster Client](#deploy-gluster-client)
  
# Gluster

Gluster file system provides a scalable parallel file system specially optimized for cloud storage. It does not have separate metadata servers, as metadata is integrated into file storage. It’s a free, scalable, open source distributed file system that works great for applications hosted on Azure.

# Deployment steps
To setup Gluster three steps need to be executed :
1. Deploy the Gluster Server
2. Deploy the Gluster Client

 ## Deploy the Glustre Server

 To get started, you need at least two nodes of any Linux distribution which will serve as server nodes (metadata server and storage server).
GlusterFS can be installed on any Linux distribution. We have used CentOS 7.3 for tests. We used VM of size DS14_V2 and attached 10 additional data disks of 1 TB each. 

Note- 
1. Before setup Gluster FS make sure you have service principal (id, secrete and tenant id) to get artifacts from Azure.
2. Since we are using Distributed-replicated volume so Gluster server nodes would be multple of 2.
3. If want to create new vnet and subnet create new resource group and If using existing resource group make sure vnet and subnet name does not exist in the resource group.


You have to provide these parameters to the template :
* _Location_ : Select the location where NC series is available(for example East US,South Central US). 
* _Vmss Name_ : Enter the virtual machine name.
* _Node_Count_ : Enter the node count.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _New/Existing Vnet Name_ : Enter the new or existing vnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _New/Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet select resource group where vnet and subnet would be created ).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Address Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Client Id_ : Enter the client ID.
* _Client secret_ : Enter the created client secret.
* _Tenant Id_ : Enter the Tenant id.
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _SSH Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'
* _Storage Disks Size_ : Select the disks size from the dropdown.
* _Storage Disks Count_ : Enter the disks count.



[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FGlusterFS-ARM%2Fgluster-server.json) 

## Deploy Glustre Client

You have to provide these parameters to the template :
* _Location_ : Select the location where NC series is available(for example East US,South Central US). 
* _Vmss Name_ : Enter the node count.
* _Node_Count_ : Enter the virtual machine name.
* _VM Size_ : Select virtual machine size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _Vnet/Subnet_ : Select new/existing from dropdown, new for a new vnet and subnet and existing for using existing vnet and subnet.
* _Existing Vnet Name_ : Enter the existing vnet name (for new Vnet/Subnet it is not required just enter any random text because text box is required).
* _Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet it is not required just enter any random text because text box is required).
* _Subnet Prefix_ : Enter the created client id.
* _Vnet Prefix_ : Enter the Vnet Prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet it is not required just enter any random value because text box is required).
* _Vnet RG_ : Enter the resource group where virtual network is created.
* _Master Name_ : Enter the hostname of instance of VMSS which name is with postfix "master". 
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _SSH Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'

[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FGlusterFS-ARM%2Fgluster-client.json)


## Testing 
 
 Gluster Client template installed IOR tools for testing, as we have setup nfs for hpcuser and provided required permissions.
  * _Server Nodes testing_ : Login to the VMs run the command "df -h" you get the volume of 9T is you given 10 disks.
  * _Server Master Node testing_ : Login to the VMs run the command "df -h" you get the volume of 9T is you given 10 disks, and run command "gluster volume info" and will get presented volume if server is not setup currectally it will show "No Volume Present".

  * _Client Testing_ : In the Client nodes we have installed IOR tools for Throuhput and IOPS testing .

		From hpcuser run-
		 export PATH=/gluster/software/mpich3/bin:$PATH
		 export LD_LIBRARY_PATH=/gluster/software/mpich3/lib:${LD_LIBRARY_PATH}

		 and 
		 mpiexec --hosts={CLIENT_HOSTNAME} -np {N_PROCS}  /gluster/software/ior/bin/ior -a MPIIO -v -B  -F -w -t 32m  -b 4G -o /mnt/gluster/test.`date +"%Y-%m-%d_%H-%M-%S"`

		 Where
		 -v - indicates verbose mode
		-B - indicates by passing cache
		-z - indicates random task ordering 
		-F - indicates file per process
		-w - indicates write operation
		-r - indicates read operation
		-t - indicates transfer rate (size of transfer in bytes)
		-b - indicates block size
		-o - indicates output test file

		CLIENT_HOSTNAME - indicates the hostname of client machine
		N_PROCS - indicates the no. of process
