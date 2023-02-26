#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: csv2json.sh csv-file"
    exit 1
fi

file="$1"
n=0

while read line
do
    if [ $n -ne 0 ]; then 
        # skip csv header
        echo "${line}" | awk -F',' '{print $4}' | awk -F'/' '{print "\"",$1,",",$2,"\","}'
    fi

    n=$((n+1))
done < "${file}"
