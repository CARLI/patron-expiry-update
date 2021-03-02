#!/bin/sh
cd `dirname $0`

RUN=somebogusdefault
if [ $# -gt 0 ]; then
  RUN=$1
fi

if [ ! -d $RUN ]; then
  echo "Input directory doesn't exist: $RUN"
  echo "Exiting..."
  exit 1
fi

if [ ! -d linked_user_reports_${RUN}_output ]; then
  echo "Directory doesn't exist; creating linked_user_reports_${RUN}_output"
  mkdir linked_user_reports_${RUN}_output
fi

do_lib() {
  lib=$1
  echo $lib
  lib_lc=`echo $lib | tr 'A-Z' 'a-z'`
  echo "python3 update_linked_accounts.py ${lib_lc} ${RUN}/linked_users_in_IZ_activeloan_${RUN}_${lib}.csv | tee linked_user_reports_${RUN}_output/patron-expiry-update-output-${lib}.txt"

  python3 update_linked_accounts.py ${lib_lc} ${RUN}/linked_users_in_IZ_activeloan_${RUN}_${lib}.csv | tee linked_user_reports_${RUN}_output/patron-expiry-update-output-${lib}.txt
}


do_lib WRH
do_lib WIU
do_lib WHE
do_lib USF
do_lib UIU
do_lib UIS
do_lib UIC
do_lib TRT
do_lib TRN
do_lib TIU
do_lib SXU
do_lib SWI
do_lib SVC
do_lib SSC
do_lib SML
do_lib SIM
do_lib SIE
do_lib SIC
do_lib SFM
do_lib SEI
