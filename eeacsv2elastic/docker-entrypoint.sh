#!/bin/bash

set -e

if [ "$LOGSTASH_RW_USERNAME" ]; then
    sed "s#RW_USERNAME#$RW_USERNAME#g" -i /root/ingest.js
    sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /root/ingest.js
    sed "s#RW_USERNAME#$RW_USERNAME#g" -i /opt/script.sh
    sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /opt/script.sh

fi

sed "s#INDEXNAME#$INDEXNAME#g" -i /root/ingest.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /root/ingest.js

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/script.sh
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /opt/script.sh
sed "s#DOWNLOADURL#$DOWNLOADURL#g" -i /opt/script.sh

exec "$@" 

