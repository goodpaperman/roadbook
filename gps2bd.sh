#! /bin/sh

if [ $# -lt 1 ]; then 
    echo "usage: gps2bd09.sh gps-file"
    exit 1
fi

source common.sh
BAIDU_MAP_AK="rNGtgGPYWcApvwpOXAMsND96iMZgYrL0"
file="$1"
end=0
n=0
line=""
data=""

while [ ${end} -eq 0 ]; 
do
    while [ $n -lt 100 ];
    do
        read -r line
        if [ $? -ne 0 -a -z "${line}" ]; then 
            # last line without LF will trigger read return error
            # so here check content of 'line', too
            end=1
            break; 
        fi

        # delete spaces
        # line="${line// /}"
        # replace space to ','
        line="${line/ /,}"
        # echo "${line}"
        if [ $n -eq 0 ]; then 
            data="${line}"
        else
            data="${data};${line}"
        fi

        n=$((n+1))
    done

    if [ $n -gt 0 ]; then 
        resp=$(curl -gs "https://api.map.baidu.com/geoconv/v1/?coords=${data}&from=1&to=5&ak=${BAIDU_MAP_AK}")
        # echo "$n: ${resp}"
        if [ ${IS_MAC} -eq 0 ]; then 
            echo "${resp}" | jq -r '.result[]|.x,.y' | sed -n '{N;s/\n/ /p}' | awk '{printf "\"%s,%s\",\n",$1,$2}'
        else
            echo "${resp}" | jq -r '.result[]|.x,.y' | gsed -n '{N;s/\n/ /p}' | awk '{printf "\"%s,%s\",\n",$1,$2}'
        fi
    fi

    n=0
done < "${file}"
