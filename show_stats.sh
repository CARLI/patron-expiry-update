cd `dirname $0`

RUN=20220502
RUN=somebogusdefault
if [ $# -gt 0 ]; then
  RUN=$1
fi

if [ ! -d $RUN ]; then
  echo "Input directory doesn't exist: $RUN"
  echo "Exiting..."
  exit 1
fi

cd linked_user_reports_${RUN}_output
for i in $(ls); do
  echo $i | cut -d- -f5 | cut -d. -f1
  egrep "TOTAL|SUCCESS|success:|updates *required|errors:" $i
  echo
done
