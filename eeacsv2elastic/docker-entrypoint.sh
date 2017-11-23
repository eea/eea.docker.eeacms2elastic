#!/bin/bash

set -e

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/ingest.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /opt/ingest.js

sed "s#LOGSTASH_RW_USERNAME#$LOGSTASH_RW_USERNAME#g" -i /opt/ingest.js
sed "s#LOGSTASH_RW_PASSWORD#$LOGSTASH_RW_PASSWORD#g" -i /opt/ingest.js

sed "s#DELIMITER#$DELIMITER#g" -i /opt/ingest.js

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/script.sh

counter=0
while [ ! "$(curl -k https://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200 2> /dev/null)" -a $counter -lt 100  ]; do
  sleep 5
  let counter=counter+1
  echo "waiting for Elasticsearch to be up ($counter/100)"
done

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/script.sh

if [ "$RESETATSTARTUP" = "YES" ] || [ ! -d "/eea.kibana.configs" ];
then
  git clone https://github.com/eea/eea.kibana.configs.git /eea.kibana.configs
  if [ -d "/eea.kibana.configs/$INDEXNAME" ];
    then
      NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=/eea.kibana.configs/$INDEXNAME/kibana_mapping.json --output=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana
      NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=/eea.kibana.configs/$INDEXNAME/kibana_analyzer.json --output=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana
      NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=/eea.kibana.configs/$INDEXNAME/kibana_data.json --output=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana
  fi
else
  cd /eea.kibana.configs
  git pull
fi

sh /opt/script.sh

exec "$@" 

