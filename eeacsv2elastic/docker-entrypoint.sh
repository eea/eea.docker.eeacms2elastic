#!/bin/bash

set -e

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/ingest.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /opt/ingest.js

sed "s#RW_USERNAME#$RW_USERNAME#g" -i /opt/ingest.js
sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /opt/ingest.js

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/script.sh

counter=0
while [ ! "$(curl http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200 2> /dev/null)" -a $counter -lt 100  ]; do
  sleep 1
  let counter=counter+1
  echo "waiting for Elasticsearch to be up ($counter/100)"
done

if [ "$RESETATSTARTUP" = "YES" ] || [ ! -d "/configurationKibana/eea.kibana.configs" ];
then
  git clone https://github.com/eea/eea.kibana.configs.git /eea.kibana.configs
  if [ -d "/eea.kibana.configs/$INDEXNAME" ];
    then
      elasticdump --input=/eea.kibana.configs/$INDEXNAME/kibana_mapping.json --output=http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/.kibana
      elasticdump --input=/eea.kibana.configs/$INDEXNAME/kibana_analyzer.json --output=http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/.kibana
      elasticdump --input=/eea.kibana.configs/$INDEXNAME/kibana_data.json --output=http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/.kibana
  fi
else
  cd /configurationKibana/eea.kibana.configs
  git pull
fi

if [ ! -d "/$KIBANACONFIGURATIONDIR/$INDEXNAME" ];
  then
    mkdir -p /$KIBANACONFIGURATIONDIR/$INDEXNAME
fi

sh /opt/script.sh

exec "$@" 

