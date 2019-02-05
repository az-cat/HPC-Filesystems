#!/bin/bash

# Groups
ADMIN_GROUP=admingroup
READER_GROUP=readergroup
WRITER_GROUP=writegroup

set -x
#set -xeuo pipefail

if [[ $(id -u) -ne 0 ]] ; then
    echo "Must be run as root"
    exit 1
fi

if [ $# < 2 ]; then
    echo "Usage: $0 <ManagementHost>"
    exit 1
fi


MGMT_HOSTNAME=$1
TEMPLATELINK=$2
JUMPBOX_NAME=$3

echo "MGS - $MGMT_HOSTNAME and templatelink - $TEMPLATELINK"

# Shares
SHARE_HOME=/share/home
SHARE_SCRATCH=/share/scratch

LUSTRE_CLIENT=/mnt/lustre

# User
HPC_USER=hpcuser
HPC_UID=7007
HPC_GROUP=hpc
HPC_GID=7007


# Installs all required packages.
install_pkgs()
{
    yum -y install epel-release
    yum -y install zlib zlib-devel bzip2 bzip2-devel bzip2-libs openssl openssl-devel openssl-libs gcc gcc-c++ nfs-utils rpcbind mdadm wget python-pip openmpi openmpi-devel automake autoconf
}

setup_user()
{
    mkdir -p $SHARE_HOME
    mkdir -p $SHARE_SCRATCH

	echo "$JUMPBOX_NAME:$SHARE_HOME $SHARE_HOME    nfs4    rw,auto,_netdev 0 0" >> /etc/fstab
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

install_lustre_repo()
{
    # Install Lustre repo
    #wget -O LustrePack.repo $TEMPLATELINK/LustrePack.repo
    mv LustrePack.repo /etc/yum.repos.d/LustrePack.repo
}

install_lustre()
{
	yum -y install kmod-lustre-client
	yum -y install lustre-client
	yum -y install lustre-client-dkms --skip-broken
}

install_ior()
{
yum -y install gcc gcc-gfortran gcc-c++
mkdir -p /lustre/software
cd /lustre/software/
wget http://www.mpich.org/static/downloads/3.1.4/mpich-3.1.4.tar.gz
tar xzf mpich-3.1.4.tar.gz
cd mpich-3.1.4
./configure --prefix=/lustre/software/mpich3/
make
make install


export PATH=/lustre/software/mpich3/bin:$PATH
export LD_LIBRARY_PATH=/lustre/software/mpich3/lib:${LD_LIBRARY_PATH}


cd /lustre/software/
yum -y install git automake
git clone https://github.com/chaos/ior.git
mv ior ior_src
cd ior_src/
./bootstrap
./configure --prefix=/lustre/software/ior/
make
make install

sudo chown -R $HPC_USER: /lustre/software
sudo chmod +777 /lustre/software


}

setup_lustrecron()
{
SETUP_L=/root/lustre.setup
cat <<EOF>/root/installlustre.sh
#!/bin/bash
if [ -e "$SETUP_L" ]; then
	echo "We're already configured, exiting..."
	exit 0
fi
mkdir /mnt/lustre
mount -t lustre $MGMT_HOSTNAME:/LustreFS /mnt/lustre
touch /root/lustre.setup
sudo chown -R $HPC_USER: /mnt
sudo chmod +777 $LUSTRE_CLIENT

 # Group for admin with r+w+e permission
	sudo groupadd $ADMIN_GROUP	
	sudo chgrp -R $ADMIN_GROUP /mnt/lustre
	sudo chmod -R 770 /mnt/lustre

	 # Group for reader with r+e permission

	sudo groupadd $READER_GROUP	
	sudo chgrp -R $READER_GROUP /mnt/lustre
	sudo chmod -R 750 /mnt/lustre

	# Group for write with w+e permission
	sudo groupadd $WRITER_GROUP	
	sudo chgrp -R $WRITER_GROUP /mnt/lustre
	sudo chmod -R 730 /mnt/lustre
EOF
	chmod 700 /root/installlustre.sh
	crontab -l > lustrecron
	echo "@reboot /root/installlustre.sh >>/root/log.txt" >> lustrecron
	crontab lustrecron
	rm lustrecron
		
}

SETUP_MARKER=/var/local/install_lustre.marker
if [ -e "$SETUP_MARKER" ]; then
    echo "We're already configured, exiting..."
    exit 0
fi

systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

install_pkgs
setup_user
install_lustre_repo
install_lustre
install_ior
setup_lustrecron

# Create marker file so we know we're configured
touch $SETUP_MARKER

shutdown -r +1 &
exit 0
