#!/bin/ksh
# set log file
log=`date +"/home/carli/logs/log.split_linked_users.%Y%m%d.%H%M"`
exec >> $log
exec 2>> $log
today=`date +"%Y%m%d"`
file1=`ls "/home/kenftp/upload/ALMA/linked_users_in_IZ_activeloan_replacemenet_$today"*`
echo "$today $file1"
if [[ -s "$file1" ]]
   then
      mkdir "/home/carli/scripts/patron-expiry-update/$today"
      mkdir "/home/carli/scripts/patron-expiry-update/linked_user_reports_${today}_output"
      /home/carli/scripts/split_linked_users.pl "$file1" "/home/carli/scripts/patron-expiry-update/$today/linked_users_in_IZ_activeloan_$today" 
      touch "/home/carli/scripts/patron-expiry-update/$today/FINISHED"
   else
      echo "no linked_users_in_IZ_activeloan_replacemenet $today file found"
fi
