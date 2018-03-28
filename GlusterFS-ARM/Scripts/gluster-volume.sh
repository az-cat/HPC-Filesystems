#!/bin/bash

# Shares
SHARE_HOME=/share/home
SHARE_SCRATCH=/share/scratch
NFS_ON_MASTER=/share/home
NFS_MOUNT=/data

# User
HPC_USER=hpcuser
HPC_UID=7007
HPC_GROUP=hpc
HPC_GID=7007

# Parameters to azure login
HOSTNAME=$(hostname)
VMSS_NAME=$1
RESOURCE_GROUP=$2
CLIENT_ID=$3
CLIENT_SECRET=$4
TENANT_ID=$5
NODE_COUNT=$6



#############################################################################
is_centos()
{
	python -mplatform | grep -qi CentOS
	return $?
}


install_basetools()
{
	#Install jq
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
	yum -y install jq

	#install azureCLI_2.0

	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
	yum check-update
	sudo yum -y install azure-cli
}
azure_access()
{
	
	az vmss list-instances -g $RESOURCE_GROUP -n $VMSS_NAME>instances.json	
	C=0
	while IFS= read -r hostName; do	   
		hosts[$C]=$hostName:/rhs/brick1/dist-vol
		((C++))		
	done < <( jq -r '.[] | (.osProfile .computerName)' <instances.json)	
	echo "${hosts[@]}"

}
hosts()
{
	#az login -u $USER_ID -p $PASSWORD
	az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
	az vmss list-instances -g $RESOURCE_GROUP -n $VMSS_NAME>instances.json
	count=0
	C=0
	while IFS= read -r hostName; do
	    hostsName[$count]=$hostName		
		((count++))
		
	done < <( jq -r '.[] | (.osProfile .computerName)' <instances.json)	
	echo "${hostsName[@]}"

}
trusted_pool()
{
	HOSTSNAME=($(hosts))

	sleep 10

	for element in ${HOSTSNAME[@]}
	do
	gluster peer prob $element
	done
	 
}
setup_gluster_volume()
{
		VOLUME=($(azure_access))
		
		sleep 10

        #gluster vol create dist-vol replica $NODE_COUNT $HOSTNAME:/rhs/brick1/dist-vol ${VOLUME[@]} force
		gluster vol create dist-vol replica 2 $HOSTNAME:/rhs/brick1/dist-vol ${VOLUME[@]} force
		echo "gluster vol create dist-vol replica 2 $HOSTNAME:/rhs/brick1/dist-vol "${VOLUME[@]}""		
		gluster volume info
		gluster volume start dist-vol
		gluster volume info
}

mkdir -p /var/local
SETUP_MARKER=/var/local/gluster-volume-setup.marker
if [ -e "$SETUP_MARKER" ]; then
    echo "We're already configured, exiting..."
    exit 0
fi

if is_centos; then
	# disable selinux
	sed -i 's/enforcing/disabled/g' /etc/selinux/config
	setenforce permissive
fi

install_basetools
trusted_pool
setup_gluster_volume

# Create marker file so we know we're configured
touch $SETUP_MARKER
exit 0
