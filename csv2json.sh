#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: csv2json.sh csv-file"
    exit 1
fi

file="$1"
n=0

echo "["
while read line
do
    if [ $n -ne 0 ]; then 
        # skip csv header
        if [ $n -gt 1 ]; then 
            echo "${line}" | awk -F',' '{print $4}' | awk -F'/' '{print "    ,{\"lat\":",$1,", \"lng\":",$2,"}"}'
        else 
            echo "${line}" | awk -F',' '{print $4}' | awk -F'/' '{print "    {\"lat\":",$1,", \"lng\":",$2,"}"}'
        fi
    fi

    n=$((n+1))
done < "${file}"
echo "]"
