#!/bin/bash

set -e

wget --force-directories DOWNLOADURL -O /OUTPUTDIR/INDEXNAME.csv 

sed "s#:text##g" -i /OUTPUTDIR/INDEXNAME.csv
sed "s#:date##g" -i /OUTPUTDIR/INDEXNAME.csv
sed "s#:url##g" -i /OUTPUTDIR/INDEXNAME.csv
sed "s#:number##g" -i /OUTPUTDIR/INDEXNAME.csv

#elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME --output=$ --type=mapping | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/mapping.json
#elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME --output=$ --type=analyzer | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/analyzer.json
#elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME --output=$ --type=data | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/data.json

elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=mapping  > KIBANACONFIGURATIONDIR/INDEXNAME/kibana_mapping.json 
elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/kibana --output=$ --type=analyzer  > KIBANACONFIGURATIONDIR/INDEXNAME/kibana_analyzer.json
elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=data  > KIBANACONFIGURATIONDIR/INDEXNAME/kibana_data.json

if [ -s /$OUTPUTDIR/$INDEXNAME.csv ]
then
    echo "File empty"
else
    curl -XPOST 'http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME/logs/_delete_by_query?conflicts=proceed&pretty' -d'{ "query": { "match_all": {} } }'
    node /opt/ingest.js
fi

