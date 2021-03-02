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


do_lib MMC
do_lib MLS
do_lib MIL
do_lib MHC
do_lib MCK
do_lib MBI
do_lib LNC
do_lib LLC
do_lib LFC
do_lib LEW
do_lib LCC
do_lib LAC
do_lib KNX
do_lib KIS
do_lib KCC
do_lib JWC
do_lib JUD
do_lib JOL
do_lib JKM
do_lib IWU
