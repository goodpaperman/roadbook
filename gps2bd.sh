#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: gps2bd09.sh gps-file"
    exit 1
fi

BAIDU_MAP_AK="rNGtgGPYWcApvwpOXAMsND96iMZgYrL0"
file="$1"
line=""

while :
do
    read -r line
    if [ $? -ne 0 -a -z "${line}" ]; then 
        break; 
    fi

    # delete spaces
    # line="${line// /}"
    # replace space to ','
    line="${line/ /,}"
    # echo "${line}"
    resp=$(curl -gs "https://api.map.baidu.com/geoconv/v1/?coords=${line}&from=1&to=5&ak=${BAIDU_MAP_AK}")
    # echo "${resp}"
    if [ ! -z "${resp}" ]; then 
        x=$(echo "${resp}" | jq '.result[0].x')
        y=$(echo "${resp}" | jq '.result[0].y')
        echo "\"$x,$y\","
    fi
done < "${file}"
