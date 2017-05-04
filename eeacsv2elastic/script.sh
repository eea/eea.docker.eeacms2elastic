#!/bin/bash

set -e

wget DOWNLOADURL -O /OUTPUTDIR/INDEXNAME.csv 

sed "s#:text##g" -i /OUTPUTDIR/INDEXNAME.csv
sed "s#:date##g" -i /OUTPUTDIR/INDEXNAME.csv
sed "s#:url##g" -i /OUTPUTDIR/INDEXNAME.csv
sed "s#:number##g" -i /OUTPUTDIR/INDEXNAME.csv

elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME --output=$ --type=mapping | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_mapping.json
elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME --output=$ --type=analyzer | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_analyzer.json
#elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME --output=$ --type=data | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_data.json

elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=mapping  | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_kibana_mapping.json 
elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/kibana --output=$ --type=analyzer  | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_kibana_analyzer.json
elasticdump --input=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana --output=$ --type=data  | grep INDEXNAME > KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_kibana_data.json

if [ -s /$OUTPUTDIR/$INDEXNAME.csv ]
then
    echo "File empty"
else
    curl -XPOST 'http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME/logs/_delete_by_query?conflicts=proceed&pretty' -d'{ "query": { "match_all": {} } }'
    node /root/ingest.js
fi

