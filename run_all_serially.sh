#!/bin/sh
cd `dirname $0`

RUN=20201130

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
do_lib SCJ
do_lib SAI
do_lib RVC
do_lib RSH
do_lib ROU
do_lib RMC
do_lib RCC
do_lib QCY
do_lib PRK
do_lib PRC
do_lib ONU
do_lib OAK
do_lib NPU
do_lib NLU
do_lib NIU
do_lib NEI
do_lib NCC
do_lib NBT
do_lib MRT
do_lib MON
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
