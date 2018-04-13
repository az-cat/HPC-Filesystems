

Table of Contents
=================
* [Gluster](#Gluster)
* [Deployment steps](#deployment-steps)
  * [Deploy the Gluster Jumpbox](#deploy-the-gluster-jumpbox)
  * [Deploy the Gluster Server](#deploy-the-gluster-server)
  * [Deploy Gluster Client](#deploy-gluster-client)
  
# Gluster(3.12.6)

Gluster file system provides a scalable parallel file system specially optimized for cloud storage. It does not have separate metadata servers, as metadata is integrated into file storage. It’s a free, scalable, open source distributed file system that works great for applications hosted on Azure.

# Deployment steps
To setup Gluster 3.12.6 version two steps need to be executed :
1. Deploy the Gluster Jumpbox
2. Deploy the Gluster Server
3. Deploy the Gluster Client

Note - We have to deploy jumpbox, server and client sequencially.

## Deploy the Gluster Jumpbox

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


[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FGlusterFS-ARM%2Fgluster-jumpbox.json) 
## Deploy the Gluster Server

 To get started, you need at least 4 nodes of any Linux distribution which will serve as server nodes (metadata server and storage server).
GlusterFS can be installed on any Linux distribution. We have used CentOS 7.3 for tests. We used VM of size DS14_V2 and attached 10 additional data disks of 1 TB each, we created logical volume on top of RAID0. 

Note- 
* Before setup Gluster FS make sure you have service principal (id, secrete and tenant id) to get artifacts from Azure.
* Since we are using Distributed-replicated volume to cover high availability feature at least 4 Gluster server nodes would be required, for more than 4 make sure it should be multiple of 2.
* If want to create new vnet and subnet create new resource group and If using existing resource group make sure vnet and subnet name does not exist in the resource group.
* To manage fault tolrance, high availability is implemented using Distributed-Replicated volume.
* To setup Gluster server there are two VMSS is required which would be deployed using the template.
   * Without postfix "master", consist (n-1) no. of instances, for example if provided node count is 10 it consist 9.
   * With postfix "master", consist 1 node, here all the instances is peer and volume is created.

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
* _Client Id_ : Enter the client ID.
* _Client secret_ : Enter the created client secret.
* _Tenant Id_ : Enter the Tenant id.
* _Jumpbox Name _ : Enter the host name of jumpbox.
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _SSH Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'
* _Storage Disks Size_ : Select the disks size from the dropdown.
* _Storage Disks Count_ : Enter the disks count.



[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FGlusterFS-ARM%2Fgluster-server.json) 

## Deploy Gluster Client

You have to provide these parameters to the template :
* _Location_ : Select the location. 
* _Vmss Name_ : Enter the VMSS prefix name.
* _Node_Count_ : Enter the node count.
* _VM Size_ : Select VMSS size from the dropdown.
* _VM Image_ : Select virtual machine Image from the dropdown.
* _Vnet/Subnet_ : Select new/existing from dropdown, new for a new vnet and subnet and existing for using existing vnet and subnet.
* _Existing Vnet Name_ : Enter the existing vnet name (for new Vnet/Subnet it is not required just enter any random text because text box is required).
* _Existing Subnet Name_ : Enter the existing subnet name (for new Vnet/Subnet it is not required just enter any random text because text box is required).
* _Subnet Prefix_ : Enter the subnet prefix of existing subnet for example 10.0.0.0/24 (for new Vnet/Subnet enter as per requirment).
* _Vnet Prefix_ :Enter the subnet prefix of existing subnet for example 10.0.0.0/16 (for new Vnet/Subnet enter as per requirment).
* _Master Name_ : Enter the hostname of instance of VMSS which name is with postfix "master". 
* _Jumpbox Name _ : Enter the host name of jumpbox.
* _Admin Username_ : This is the name of the administrator account to create on the VM.
* _SSH Key Data_ : The public SSH key to associate with the administrator user. Format has to be on a single line 'ssh-rsa key'

[![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faz-cat%2FHPC-Filesystems%2Fmaster%2FGlusterFS-ARM%2Fgluster-client.json)

## Deploy using azure cli

To deploy the template using azure cli we have to use below steps-

* Download the parameters file (gfsjumpbox-parameters.json, gfsserver-parameters.json and gfsclient-parameters.json) on local machin .
* Edit the parameters file, provide all the parameters.
* To deploy gluster server and client use below command-
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/GlusterFS-ARM/gluster-jumpbox.json --parameters @gfsjumpbox-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/GlusterFS-ARM/gluster-server.json --parameters @gfsserver-parameters.json
  * az group deployment create -g {Resource group} --template-uri https://raw.githubusercontent.com/az-cat/HPC-Filesystems/master/GlusterFS-ARM/gluster-client.json --parameters @gfsclient-parameters.json




## Testing 
 
 Gluster Client template installed IOR tools for testing, as we have setup nfs for hpcuser and provided required permissions.
  * _Server Nodes testing_ : Login to the VMs run the command "df -h" you get the volume of 9T is you given 10 disks.
     
	     [adminuser@gfsser000000 ~]$ df -h
		Filesystem                     Size  Used Avail Use% Mounted on
		/dev/sda2                       30G  1.6G   28G   6% /
		devtmpfs                       6.9G     0  6.9G   0% /dev
		tmpfs                          6.9G     0  6.9G   0% /dev/shm
		tmpfs                          6.9G  8.4M  6.9G   1% /run
		tmpfs                          6.9G     0  6.9G   0% /sys/fs/cgroup
		/dev/sda1                      497M   87M  411M  18% /boot
		/dev/sdb1                       28G   45M   26G   1% /mnt/resource
		/dev/mapper/rhgs--data-brick1  9.0T   34M  9.0T   1% /rhs/brick1
		tmpfs                          1.4G     0  1.4G   0% /run/user/1000


  * _Server Master Node testing_ : Login to the VMs run the command "df -h" you get the volume of 9T if you given 10 disks, and run command "gluster volume info" and will get presented volume if server is not setup currectally it will show "No Volume Present".
  
		  [root@gfsmaster000000 ~]# gluster volume info

		Volume Name: dist-vol
		Type: Distributed-Replicate
		Volume ID: 2dde31ee-ba67-42c4-9a40-333d6387bb9e
		Status: Started
		Snapshot Count: 0
		Number of Bricks: 2 x 2 = 4
		Transport-type: tcp
		Bricks:
		Brick1: gfsmaster000000:/rhs/brick1/dist-vol
		Brick2: gfs000000:/rhs/brick1/dist-vol
		Brick3: gfs000001:/rhs/brick1/dist-vol
		Brick4: gfs000002:/rhs/brick1/dist-vol
		Options Reconfigured:
		transport.address-family: inet
		nfs.disable: on
		performance.client-io-threads: off

  

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
