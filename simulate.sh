#! /bin/sh

if [ ! -f data.wait ]; then 
    sh land2wait.sh data.land > data.wait
else 
    echo "use data.wait"
fi

sh wait.sh data.wait
echo "simulate done!"
