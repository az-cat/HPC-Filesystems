SETUP_MARKER=/var/local/install_beegfs_ha.marker
if [ -e "$SETUP_MARKER" ]; then
    echo "We're already configured, exiting..."
    exit 0
fi
setup_ha()
{
	
		sudo beegfs-ctl --addmirrorgroup --automatic --nodetype=storage
		beegfs-ctl --listmirrorgroups --nodetype=storage		
		beegfs-ctl --listtargets --mirrorgroups
		sudo beegfs-ctl --addmirrorgroup --automatic --nodetype=meta
		sleep 10
		beegfs-ctl --setpattern --numtargets=4 --chunksize=512k --buddymirror /share/scratch
		
		sleep 20

		beegfs-ctl --mirrormd
	

}
setup_ha
touch $SETUP_MARKER
