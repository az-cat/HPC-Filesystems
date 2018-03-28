#!/bin/bash
input="parameters.csv"
resourcegroup=$1
if [ ! $resourcegroup ]; then
 echo "Please provide resourcegroup name. Exiting now.";
 exit 1;
fi

while IFS=',' read -r f1 f2
do 
  echo "$resourcegroup $f1 $f2"
  azure vmss create -g $resourcegroup -n $f1 --parameter-file $f2
done < "$input"
