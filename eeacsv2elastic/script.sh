#!/bin/bash

set -e

mkdir -p /$OUTPUTDIR

export TESTZIP=$(echo $DOWNLOADURL | grep gz)
if [ -z "$TESTZIP" ]
  wget $DOWNLOADURL -O /$OUTPUTDIR/INDEXNAME.csv 
else
  wget $DOWNLOADURL -O /$OUTPUTDIR/INDEXNAME.csv.gz
  gzip -d /$OUTPUTDIR/INDEXNAME.csv.gz
fi

sed "s#:text##g"   -i /$OUTPUTDIR/INDEXNAME.csv
sed "s#:date##g"   -i /$OUTPUTDIR/INDEXNAME.csv
sed "s#:url##g"    -i /$OUTPUTDIR/INDEXNAME.csv
sed "s#:number##g" -i /$OUTPUTDIR/INDEXNAME.csv

if [ -s "/$OUTPUTDIR/INDEXNAME.csv" ]
then
    curl --user $RW_USERNAME:$RW_PASSWORD -XPOST 'http://elasticsearch:9200/INDEXNAME/logs/_delete_by_query?conflicts=proceed&pretty' -d'{ "query": { "match_all": {} } }'
    node /opt/ingest.js
else
    echo "File empty"
fi

export TESTKIBANAINDEX=$(curl --user $RW_USERNAME:$RW_PASSWORD -s 'http://elasticsearch:9200/_cat/indices?' | grep .kibana)

if [ ! -z "$TESTKIBANAINDEX" ]
then
  mkdir -p /$KIBANACONFIGURATIONDIR/INDEXNAME
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=mapping   > /$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_mapping.json
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=analyzer  > /$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_analyzer.json
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=data      > /$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_data.json
fi
export TESTKIBANAINDEX=''
