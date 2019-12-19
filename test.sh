#!/bin/bash

/usr/bin/python3 /usr/local/bin/motuclient -u $(grep CMEMS_USER /home/motutest/cmems_secret.py | sed -e "s/'$//" -e "s/^.*'//") -p $(grep CMEMS_PASS /home/motutest/cmems_secret.py | sed -e "s/'$//" -e "s/^.*'//") -m http://nrt.cmems-du.eu/motu-web/Motu -s GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS -d global-analysis-forecast-phy-001-024-hourly-t-u-v-ssh -x -72 -X -60 -y 10 -Y 20 -t "2019-12-11 00:00:00" -T "2019-12-28 23:59:59" -z 0.493 -Z 0.4942 -v thetao -v zos -v uo -v vo

ls -lhtr

if [ -e "/home/motutest/data.nc" ]; then
  echo "Success, data file present"
  exit 0
else
  echo "Fail, data file not present"
  exit 1
fi

