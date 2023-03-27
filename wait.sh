#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: wait.sh wait-file"
    exit 1
fi

waitfile="$1"
line=""
sec=0

while :
do
    read -r line
    if [ $? -ne 0 -a -z "${line}" ]; then 
        break; 
    fi

    sec=$(echo "${line}" | awk '{print $1}')
    echo "sleep ${line}"
    sleep ${sec}
done < "${waitfile}"
