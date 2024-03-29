#! /bin/sh

if [ $# -lt 2 ]; then 
    echo "usage: csv2land.sh csv-file bd-file"
    exit 1
fi

source ./common.sh
csvfile="$1"
bdfile="$2"
line=""
prevstamp=0
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
        time=$(echo "${line}" | awk -F',' '{print $2}')
        if [ ${IS_MAC} -eq 1 ]; then 
            timestamp=$(date -j -f "%Y-%m-%d %H:%M:%S" "${time}" "+%s")
        else
            timestamp=$(date -d "${time}" "+%s")
        fi
    
        # read coodinate from data.bd instead of data.csv to prevent data incorrect
        #data=$(echo "${line}" | awk -F',' '{print $4}' | awk -F'/' '{print "lng:",$1,",lat:",$2}')
        # note, sed index is 1 based, and csv file have a header take line 0, so it just match..
        data=$(sed -n "${n}p" "${bdfile}")
        x=$(echo "${data}" | awk -F',|"' '{print $2}')
        y=$(echo "${data}" | awk -F',|"' '{print $3}')
        # echo "data:${data},x:$x,y:$y"
        label=$(echo "${line}" | awk -F',' '{print $5}')
    
        if [ $n -eq 1 ]; then 
            # insert a 10 second stay for first record
            echo "{lng:$x,lat:$y,html:'${label}',pauseTime:10},"
        else
            # compute elapse from second record
            elapse=$((timestamp - prevstamp))
            echo "{lng:$x,lat:$y,html:'${label}',pauseTime:${elapse}},"
        fi
    
        prevstamp=${timestamp}
    fi

    n=$((n+1))
done < "${csvfile}"
