RUN=20210825
cd linked_user_with_role_expiration_date_${RUN}_output 
for i in $(ls); do
  echo $i
  echo $i | cut -d- -f5 | cut -d. -f1
  egrep "TOTAL|SUCCESS|success:|updates *required|errors:" $i
  echo
done
