#!/bin/bash
# Install jq
wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x ./jq
sudo cp jq /usr/bin

if [ "$#" -lt 3 ]; then
     echo "Usage: $0 <ResourceGroup> <VMSS Name> <Action (start,deallocate,restart)>"
     exit 1
fi
rg=$1
vmssname=$2
action=$3

# Store vmlist json
azure vmssvm list -g $rg -n $vmssname --json > vmlist.json
# Loop through all the VMs with action
declare -A values=( ) descriptions=( )
while IFS= read -r description &&
      IFS= read -r key &&
      IFS= read -r value; do
azure vmss $action -g $rg -n $vmssname --instance-ids $value
done < <(jq -r '.[] | (.name,.location, .instanceId)' <vmlist.json)
rm vmlist.json
