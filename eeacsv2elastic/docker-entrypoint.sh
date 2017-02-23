#!/bin/bash

set -e

if [ "$LOGSTASH_RW_USERNAME" ]; then
    sed "s#LOGSTASH_RW_USERNAME#$LOGSTASH_RW_USERNAME#g" -i /root/ingest.js
    sed "s#LOGSTASH_RW_PASSWORD#$LOGSTASH_RW_PASSWORD#g" -i /root/ingest.js
fi

sed "s#INDEXNAME#$INDEXNAME#g" -i /root/ingest.js
sed "s#INDEXNAME#$INDEXNAME#g" -i /root/ingest.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /root/ingest.js

exec "$@" 

