#!/bin/bash
beegfs-check-servers > commandoutput.txt
FILE="commandoutput.txt"
res=()
while read line; do
if [ "$line" != "Management" ] &&
 [ "$line" != "Storage" ] && 
 [ "$line" != "Metadata" ] &&
 [ "$line" != "==========" ]
then
IFS=" " read -ra NAMES <<< "$line"

if [[ " ${res[*]} " != *"${NAMES[0]}"* ]]; then
 res+="${NAMES[0]}
"
fi

fi
done < $FILE
echo "$res" > BeeGFSNodes.txt
echo "Following nodes are stored in BeeGFSNodes.txt file."
cat BeeGFSNodes.txt
