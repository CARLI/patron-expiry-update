#!/bin/sh
cd `dirname $0`

today=`date +"%Y%m%d"`
flag="/home/carli/scripts/patron-expiry-update/$today/FINISHED"

max=120
cnt=0
while true; do
  echo "cnt: $cnt"
  if [ -f "${flag}" ]; then
    echo "flag file exists: $flag"
    echo "executing..."
    break
  else
    echo "flag file doesn't exist: $flag"
    echo "sleeping 60 seconds..."
    sleep 60
    cnt=$(expr $cnt + 1)
    if [ $cnt -gt $max ]; then
      echo "timed out waiting for flag file: $flag"
      exit 1
    fi
  fi
done

date

echo "executing batch 1..."
./batch1.sh $today &
echo "executing batch 2..."
./batch2.sh $today &
echo "executing batch 3..."
./batch3.sh $today &
echo "executing batch 4..."
./batch4.sh $today &
wait

date
