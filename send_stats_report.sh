#!/bin/sh
cd `dirname $0`

RUN=somebogusdefault
if [ $# -gt 0 ]; then
  RUN=$1
fi

FROMEMAIL="noreply@carli.illinois.edu"
TOEMAIL="systemservices@carli.illinois.edu,cedelis@uillinois.edu"
TOEMAIL="cedelis@uillinois.edu"
FILENAME="/tmp/show_stats.$$.txt"
USERNAME=$(cat sparkpost_username.txt)
PASSWORD=$(cat sparkpost_password.txt)


sh ./show_stats.sh $RUN > $FILENAME

swaks -server smtp.carli.illinois.edu:587 \
  -tls \
 --auth-user "${USERNAME}" \
 --auth-password "${PASSWORD}" \
 --to ${TOEMAIL} \
 --from ${FROMEMAIL} \
 --attach-type "text/plain" \
 --attach-name patron_expiry_update_${RUN}.txt \
 --attach "${FILENAME}" \
 --header "Subject: Alma patron expiry update report" \
 --body "The statistics report is attached to this email."

/bin/rm "${FILENAME}"

