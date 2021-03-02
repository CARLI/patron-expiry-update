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

do_lib IVC
do_lib ISU
do_lib ISL
do_lib IMS
do_lib ILC
do_lib IIT
do_lib IEC
do_lib ICC
do_lib HRT
do_lib GSU
do_lib GRN
do_lib ERK
do_lib ELM
do_lib EIU
do_lib DPU
do_lib DOM
do_lib DAC
do_lib CTU
do_lib CSU
do_lib CSC
do_lib CON
do_lib COL
do_lib COD
do_lib BRA
do_lib BHC
do_lib BEN
do_lib AUG
do_lib ARU
do_lib ADL
