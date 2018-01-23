#!/bin/bash

set -e

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/ingestData.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /opt/ingestData.js

sed "s#LOGSTASH_RW_USERNAME#$LOGSTASH_RW_USERNAME#g" -i /opt/ingestData.js
sed "s#LOGSTASH_RW_PASSWORD#$LOGSTASH_RW_PASSWORD#g" -i /opt/ingestData.js

sed "s#DELIMITER#$DELIMITER#g" -i /opt/ingestData.js
sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/ingestData.sh

echo "waiting until elasticsearch is up"
until curl -k https://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200 &>/dev/null; do sleep 5; done
echo "elasticsearch is up"

if [[ "$RESETATSTARTUP" = "YES" ]] || [[ ! -d "/eea.kibana.configs" ]];
then
  rm -rf /eea.kibana.configs
  git clone https://github.com/eea/eea.kibana.configs.git /eea.kibana.configs
  if [[ -d "/eea.kibana.configs/$INDEXNAME" ]];
    then
      echo "folder /eea.kibana.configs/$INDEXNAME found, importing the dashboard"
      sh /opt/ingestConfiguration.sh
  fi
else
  cd /eea.kibana.configs
  git pull
fi

sh /opt/ingestData.sh

exec "$@" 
