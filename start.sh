#! /bin/sh

sh csv2txt.sh data.csv > data.txt
sed '/JSON_DATA_PLACETAKER_BEGIN/ r data.txt' index.html > index.data.html
open index.data.html
