#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: csv2gps.sh csv-file"
    exit 1
fi

file="$1"
line=""
n=0

while :
do
    read -r line
    if [ $? -ne 0 -a -z "${line}" ]; then 
        # last line without LF will trigger read return error
        # so here check content of 'line', too
        break; 
    fi

    if [ $n -ne 0 ]; then 
        # skip csv header
        echo "${line}" | awk -F',' '{print $4}' | awk -F'/' '{print $1,$2}'
    fi

    n=$((n+1))
done < "${file}"
