#!/bin/bash

# Shares
SHARE_HOME=/share/home
SHARE_SCRATCH=/share/scratch
NFS_ON_MASTER=/share/home
NFS_MOUNT=/data
# Groups
ADMIN_GROUP=admingroup
READER_GROUP=readergroup
WRITER_GROUP=writegroup

# User
HPC_USER=hpcuser
HPC_UID=7007
HPC_GROUP=hpc
HPC_GID=7007

# Parameter
MASTER_NAME=$1

#############################################################################



is_centos()
{
	python -mplatform | grep -qi CentOS
	return $?
}
setup_disks()
{
    mkdir -p $SHARE_HOME
    mkdir -p $SHARE_SCRATCH
	mkdir -p $SHARE_APPS

	chown $HPC_USER:$HPC_GROUP $SHARE_APPS
}
mount_nfs()
{
	log "install NFS"
	mkdir -p ${NFS_MOUNT}
	log "mounting NFS on " ${MASTER_NAME}
	showmount -e ${MASTER_NAME}
	mount -t nfs ${MASTER_NAME}:${NFS_ON_MASTER} ${NFS_MOUNT}
	
	echo "${MASTER_NAME}:${NFS_ON_MASTER} ${NFS_MOUNT} nfs defaults,nofail  0 0" >> /etc/fstab
}
install_pkgs()
{
    yum -y install epel-release
    yum -y install zlib zlib-devel bzip2 bzip2-devel bzip2-libs openssl openssl-devel openssl-libs gcc gcc-c++ nfs-utils rpcbind mdadm wget python-pip openmpi openmpi-devel automake autoconf
}
setup_user()
{
    mkdir -p $SHARE_HOME
    mkdir -p $SHARE_SCRATCH

	echo "$MASTER_NAME:$SHARE_HOME $SHARE_HOME    nfs4    rw,auto,_netdev 0 0" >> /etc/fstab
	mount -a
	mount
   
    groupadd -g $HPC_GID $HPC_GROUP

    # Don't require password for HPC user sudo
    echo "$HPC_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    
    # Disable tty requirement for sudo
    sed -i 's/^Defaults[ ]*requiretty/# Defaults requiretty/g' /etc/sudoers

	useradd -c "HPC User" -g $HPC_GROUP -d $SHARE_HOME/$HPC_USER -s /bin/bash -u $HPC_UID $HPC_USER

    chown $HPC_USER:$HPC_GROUP $SHARE_SCRATCH	
}
install_gluster_client()
{
	 yum -y install glusterfs-fuse
	 mkdir /mnt/gluster
	 mount -t glusterfs $MASTER_NAME:/dist-vol  /mnt/gluster
	 sudo chown -R $HPC_USER: /mnt
	 sudo chmod +777 /mnt/gluster
}
install_ior()
{
	# compile mpich
	yum -y install gcc gcc-gfortran gcc-c++
	mkdir -p /gluster/software
	cd /gluster/software/
	wget http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz
	tar xzf mpich-3.1.4.tar.gz
	cd mpich-3.1.4
	./configure --prefix=/gluster/software/mpich3/
	make
	make install

	# Path variable
	export PATH=/gluster/software/mpich3/bin:$PATH
	export LD_LIBRARY_PATH=/gluster/software/mpich3/lib:${LD_LIBRARY_PATH}

	# compile IOR
	cd /gluster/software/
	yum -y install git automake
	git clone https://github.com/chaos/ior.git
	mv ior ior_src
	cd ior_src/
	./bootstrap
	./configure --prefix=/gluster/software/ior/
	make
	make install

	sudo chown -R $HPC_USER: /gluster/software
	sudo chmod +777 /gluster/software
}
group_permission()
{
    # Group for admin with r+w+e permission
	sudo groupadd $ADMIN_GROUP	
	sudo chgrp -R $ADMIN_GROUP /mnt/gluster
	sudo chmod -R 770 /mnt/gluster

	 # Group for reader with r+e permission

	sudo groupadd $READER_GROUP	
	sudo chgrp -R $READER_GROUP /mnt/gluster
	sudo chmod -R 750 /mnt/gluster

	# Group for write with w+e permission
	sudo groupadd $WRITER_GROUP	
	sudo chgrp -R $WRITER_GROUP /mnt/gluster
	sudo chmod -R 730 /mnt/gluster
}

if is_centos; then
	# disable selinux
	sed -i 's/enforcing/disabled/g' /etc/selinux/config
	setenforce permissive
fi
SETUP_MARKER=/var/tmp/gluster-client-setup.marker
if [ -e "$SETUP_MARKER" ]; then
    echo "We're already configured, exiting..."
    exit 0
fi
#setup_disks
install_pkgs
setup_user
install_gluster_client
install_ior
group_permission
#mount_nfs
# Create marker file so we know we're configured
touch $SETUP_MARKER
exit 0