#!/bin/sh
cd `dirname $0`

RUN=somebogusdefault
if [ $# -gt 0 ]; then
  RUN=$1
fi

if [ ! -d linked_user_with_role_expiration_date ]; then
  echo "Input directory doesn't exist: linked_user_with_role_expiration_date"
  echo "Exiting..."
  exit 1
fi

if [ ! -d linked_user_with_role_expiration_date_${RUN}_output ]; then
  echo "Directory doesn't exist; creating linked_user_with_role_expiration_date_${RUN}_output"
  mkdir linked_user_with_role_expiration_date_${RUN}_output
fi

do_lib() {
  lib=$1
  echo $lib
  lib_lc=`echo $lib | tr 'A-Z' 'a-z'`
  echo "python3 null_out_patron_roles.py ${lib_lc} linked_user_with_role_expiration_date/linked_users_in_IZ_with_role_expiration_date_${RUN}_${lib}.csv | tee -a linked_user_with_role_expiration_date_${RUN}_output/linked-user-with-role-expiration-date-output-${lib}.txt"

  python3 null_out_patron_roles.py ${lib_lc} linked_user_with_role_expiration_date/linked_users_in_IZ_with_role_expiration_date_${RUN}_${lib}.csv | tee -a linked_user_with_role_expiration_date_${RUN}_output/linked-user-with-role-expiration-date-output-${lib}.txt
}


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
