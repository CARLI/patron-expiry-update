RUN=20210825
cd linked_user_with_role_expiration_date_${RUN}_output 
for i in $(ls); do
  echo $i
  egrep "TOTAL|SUCCESS|success:|updates *required|errors:" $i
  echo
done
