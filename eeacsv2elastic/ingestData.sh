#!/bin/bash

set -e

mkdir -p /$OUTPUTDIR

export TESTZIP=$(echo $DOWNLOADURL | grep gz)
if [[ ! -z "$TESTZIP" ]]
then
  wget -q $DOWNLOADURL -O /$OUTPUTDIR/INDEXNAME.csv.gz
  gzip -f -d /$OUTPUTDIR/INDEXNAME.csv.gz
else
  wget $DOWNLOADURL -O /$OUTPUTDIR/INDEXNAME.csv
fi

sed "s#:text##g"   -i /$OUTPUTDIR/INDEXNAME.csv
sed "s#:date##g"   -i /$OUTPUTDIR/INDEXNAME.csv
sed "s#:url##g"    -i /$OUTPUTDIR/INDEXNAME.csv
sed "s#:number##g" -i /$OUTPUTDIR/INDEXNAME.csv

if [[ -s "/$OUTPUTDIR/INDEXNAME.csv" ]]
then
    echo "deleting index INDEXNAME"
    curl -k --user $LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD -XPOST -H'Content-Type: application/json' 'https://elasticsearch:9200/INDEXNAME/logs/_delete_by_query?conflicts=proceed&pretty' -d'{ "query": { "match_all": {} } }'
    echo "index INDEXNAME deleted"
    echo "ingesting data into INDEXNAME index "
    node /opt/ingestData.js
    echo "ingesting done"
else
    echo "file is empty"
fi

export TESTKIBANAINDEX=$(curl -k --user $LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD -s 'https://elasticsearch:9200/_cat/indices?' | grep .kibana)

if [[ ! -z "$TESTKIBANAINDEX" ]]
then
  rm -rf /$KIBANACONFIGURATIONDIR/INDEXNAME
  mkdir -p /$KIBANACONFIGURATIONDIR/INDEXNAME
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input-index=.kibana --headers='{"Content-Type": "application/json"}' --input="https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200" --output=/$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_mapping.json --type=mapping
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input-index=.kibana --headers='{"Content-Type": "application/json"}' --input="https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200" --output=/$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_analyzer.json --type=analyzer
  NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --input-index=.kibana --headers='{"Content-Type": "application/json"}' --input="https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200" --output=/$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_data.json --type=data
fi

