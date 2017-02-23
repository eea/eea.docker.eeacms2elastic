#!/bin/bash

set -e

if [ "$LOGSTASH_RW_USERNAME" ]; then
    sed "s#RW_USERNAME#$RW_USERNAME#g" -i /root/ingest.js
    sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /root/ingest.js
fi

sed "s#INDEXNAME#$INDEXNAME#g" -i /root/ingest.js
sed "s#INDEXNAME#$INDEXNAME#g" -i /root/ingest.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /root/ingest.js

exec "$@" 

