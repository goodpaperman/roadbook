#! /bin/sh

if [ $# -lt 2 ]; then 
    echo "usage: csv2land.sh csv-file bd-file"
    exit 1
fi

# @brief: is MacOS platform
#         mac date a little different with other
# @retval: 0 - no
# @retval: 1 - yes
function is_macos()
{
    local os="${OSTYPE/"darwin"//}"
    if [ "$os" != "$OSTYPE" ]; then
        # darwin: macos
        return 1
    else
        return 0
    fi
}

is_macos
IS_MAC=$?
csvfile="$1"
bdfile="$2"
line=""
prevstamp=0
n=0

while :
do
    read -r line
    if [ $? -ne 0 -a -z "${line}" ]; then 
        break; 
    fi

    if [ $n -ne 0 ]; then 
        # skip csv header
        time=$(echo "${line}" | awk -F',' '{print $2}')
        if [ ${IS_MAC} -eq 1 ]; then 
            timestamp=$(date -j -f "%Y-%m-%d %H:%M:%S" "${time}" "+%s")
        else
            timestamp=$(date -d "${time}" "+%s")
        fi

        if [ ${prevstamp} -ne 0 ]; then 
            elapse=$((timestamp - prevstamp))
            # read coodinate from data.bd instead of data.csv to prevent data incorrect
            #data=$(echo "${line}" | awk -F',' '{print $4}' | awk -F'/' '{print "lng:",$1,",lat:",$2}')
            data=$(sed -n "${n}p" "${bdfile}")
            x=$(echo "${data}" | awk -F',|"' '{print $2}')
            y=$(echo "${data}" | awk -F',|"' '{print $3}')
            # echo "d9ata:${data},x:$x,y:$y"
            # too many labels
            label=$(echo "${line}" | awk -F',' '{print $5}')
            echo "{lng:$x,lat:$y,html:'${label}',pauseTime:${elapse}},"
        fi
        prevstamp=${timestamp}
    fi

    n=$((n+1))
done < "${csvfile}"
