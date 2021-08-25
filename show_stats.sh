RUN=20210802
cd linked_user_reports_${RUN}_output
for i in $(ls); do
  echo $i | cut -d- -f5 | cut -d. -f1
  egrep "TOTAL|SUCCESS|success:|updates *required|errors:" $i
  echo
done
