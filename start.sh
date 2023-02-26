#! /bin/sh

if [ ! -f data.csv ]; then 
    echo "please put gps data into 'data.csv' first!"
    exit 1
fi

if [ ! -f data.raw ]; then 
    echo "start generate file: data.raw, extract cooridnate from gps data"
    sh csv2txt.sh data.csv > data.raw
    # data.txt need re-generate
    rm data.txt
else 
    echo "use file: data.raw"
fi 

if [ ! -f data.txt ]; then 
    echo "start generate file: data.txt, convert gps coordinate to baidu map"
    sh gps2bd09.sh data.raw > data.txt
    # index.data.html need re-generate
    rm index.data.html
else 
    echo "use file: data.txt"
fi

if [ ! -f index.data.html ]; then 
    echo "start generate file: index.data.html, the destinate file"
    sed '/JSON_DATA_PLACETAKER_BEGIN/ r data.txt' index.html > index.data.html
else 
    echo "use file: index.data.html"
fi

open index.data.html
