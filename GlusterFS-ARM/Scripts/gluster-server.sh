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
# Parameters 
#DISKS_COUNT=$1

#############################################################################

#Added - RAID0

BLACKLIST="/dev/sda|/dev/sdb"
is_centos()
{
	python -mplatform | grep -qi CentOS
	return $?
}

scan_for_new_disks() {
    # Looks for unpartitioned disks
    declare -a RET
    DEVS=($(ls -1 /dev/sd*|egrep -v "${BLACKLIST}"|egrep -v "[0-9]$"))
    for DEV in "${DEVS[@]}";
    do
        # Check each device if there is a "1" partition.  If not,
        # "assume" it is not partitioned.
        if [ ! -b ${DEV}1 ];
        then
            RET+="${DEV} "
        fi
    done
    echo "${RET}"
}

get_disk_count() {
    DISKCOUNT=0
    for DISK in "${DISKS[@]}";
    do 
        DISKCOUNT+=1
    done;
    echo "$DISKCOUNT"
}

setup_raid()
{
	#Update system and install mdadm for managing RAID
	yum -y update
	yum install mdadm -y

	#Verify attached data disks
	ls -l /dev | grep sd
	
	DISKS=($(scan_for_new_disks))
    echo "Disks are ${DISKS[@]}"
    declare -i DISKCOUNT
    DISKCOUNT=$(get_disk_count) 
    echo "Disk count is $DISKCOUNT"

	sleep 10
	#Create RAID md device
	mdadm -C /dev/md0 -l raid0 -n "$DISKCOUNT" "${DISKS[@]}"
}
setup_raid
get_disks_no()
{
	 DISKS=($(scan_for_new_disks))
	 declare -i DISKCOUNT
	 DISKCOUNT=$(get_disk_count)
	 echo "$DISKCOUNT"
}
COUNT=$(get_disks_no)
NewDiskCount=`expr $COUNT - 1`
logicalvolume=`expr $NewDiskCount \* 1024`g

raid0_volume()
{
	

	mdadm --examine --scan | sudo tee /etc/mdadm.conf 

	pvcreate --dataalignment 1024K /dev/md0
	vgcreate --physicalextentsize 256K rhgs-data /dev/md0
	lvcreate -L $logicalvolume -T rhgs-data/brickpool -c 256K
	lvchange --zero n rhgs-data/brickpool
	lvcreate -V $logicalvolume -T rhgs-data/brickpool -n brick1

	mkfs.xfs -f -K -i size=512 -n size=8192 /dev/rhgs-data/brick1
    mkdir -p /rhs/brick1

	sleep 10

	echo -e "/dev/rhgs-data/brick1\t/rhs/brick1\txfs\tdefaults,inode64,nobarrier,noatime,nouuid 0 2" | sudo tee -a /etc/fstab
	mount -a

}

#End -RAID0



mount_nfs()
{
	log "install NFS"
	mkdir -p ${NFS_MOUNT}
	log "mounting NFS on " ${MASTER_NAME}
	showmount -e ${MASTER_NAME}
	mount -t nfs ${MASTER_NAME}:${NFS_ON_MASTER} ${NFS_MOUNT}
	
	echo "${MASTER_NAME}:${NFS_ON_MASTER} ${NFS_MOUNT} nfs defaults,nofail  0 0" >> /etc/fstab
}
setup_user()
{
	if is_centos; then
		yum -y install nfs-utils nfs-utils-lib	
	fi

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
setup_python_centos()
{
	yum -y install epel-release
	yum -y install python34 python34-devel
	curl -O https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py
}

install_pkgs()
{
    yum -y install epel-release
    yum -y install zlib zlib-devel bzip2 bzip2-devel bzip2-libs openssl openssl-devel openssl-libs gcc gcc-c++ nfs-utils rpcbind mdadm wget python-pip https://buildlogs.centos.org/c7.1511.u/kernel/20161024152721/3.10.0-327.36.3.el7.x86_64/kernel-3.10.0-327.36.3.el7.src.rpm https://buildlogs.centos.org/c7.1511.u/kernel/20161024152721/3.10.0-327.36.3.el7.x86_64/kernel-devel-3.10.0-327.36.3.el7.x86_64.rpm https://buildlogs.centos.org/c7.1511.u/kernel/20161024152721/3.10.0-327.36.3.el7.x86_64/kernel-headers-3.10.0-327.36.3.el7.x86_64.rpm https://buildlogs.centos.org/c7.1511.u/kernel/20161024152721/3.10.0-327.36.3.el7.x86_64/kernel-tools-libs-devel-3.10.0-327.36.3.el7.x86_64.rpm openmpi openmpi-devel automake autoconf
}

setup_glusterserver()
{
	log "setup_glusterserver"
	if is_centos; then
		yum -y install centos-release-gluster
		yum -y install  glusterfs-cli glusterfs-geo-replication glusterfs-fuse glusterfs-server glusterfs
		systemctl enable glusterd.service
		systemctl enable glusterfsd.service
		systemctl start glusterd.service
		systemctl start glusterfsd.service
		systemctl status glusterfsd.service
		systemctl status glusterd.service
	fi

	
}


mkdir -p /var/local
SETUP_MARKER=/var/local/Gluster-setup.marker
if [ -e "$SETUP_MARKER" ]; then
    echo "We're already configured, exiting..."
    exit 0
fi

if is_centos; then
	# disable selinux
	sed -i 's/enforcing/disabled/g' /etc/selinux/config
	setenforce permissive
fi

raid0_volume
setup_glusterserver

# Create marker file so we know we're configured
touch $SETUP_MARKER
exit 0
