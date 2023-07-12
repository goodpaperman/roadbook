#! /bin/sh

if [ ! -f data.csv ]; then 
    echo "please put gps data into 'data.csv' first!"
    exit 1
fi

if [ ! -f data.gps ]; then 
    echo "start generate file: data.gps, extract gps from csv data"
    sh csv2gps.sh data.csv > data.gps
    # data.bd need re-generate
    rm data.bd
else 
    echo "use file: data.gps"
fi 

if [ ! -f data.bd ]; then 
    echo "start generate file: data.bd, convert gps to baidu coordinate"
    sh gps2bd.sh data.gps > data.bd
    # index.data.html need re-generate
    rm data.land
else 
    echo "use file: data.bd"
fi

if [ ! -f data.land ]; then 
    echo "start generate file: data.land, extract land and time from csv & baidu coordinate"
    sh bd2land.sh data.csv data.bd > data.land
    # final file need re-generate
    rm index.data.html
    rm data.wait
else 
    echo "use file: data.land"
fi 

if [ ! -f index.data.html ]; then 
    echo "start generate file: index.data.html, the final file"
    sed '/BD_DATA_PLACETAKER/ r data.bd' index.html | sed '/LAND_DATA_PLACETAKER/ r data.land' > index.data.html
else 
    echo "use file: index.data.html"
fi

open index.data.html
