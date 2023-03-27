#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: land2wait.sh land-file"
    exit 1
fi

landfile="$1"
awk -F",|:|}" '{print $8,$6}' "${landfile}" 

