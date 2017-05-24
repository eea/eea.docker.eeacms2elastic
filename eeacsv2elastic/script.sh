#!/bin/bash

set -e

mkdir -p /$OUTPUTDIR
wget $DOWNLOADURL -O /$OUTPUTDIR/INDEXNAME.csv 

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
  elasticdump --input=http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=mapping   > /$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_mapping.json
  elasticdump --input=http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=analyzer  > /$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_analyzer.json
  elasticdump --input=http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=data      > /$KIBANACONFIGURATIONDIR/INDEXNAME/kibana_data.json
fi
export TESTKIBANAINDEX=''
