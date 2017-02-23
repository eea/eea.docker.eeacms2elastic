#!/bin/bash

set -e

wget $DOWNLOADURL -O /$OUTPUTDIR/$INDEXNAME.csv 

sed "s#:text##g" -i /$OUTPUTDIR/$INDEXNAME.csv
sed "s#:date##g" -i /$OUTPUTDIR/$INDEXNAME.csv
sed "s#:url##g" -i /$OUTPUTDIR/$INDEXNAME.csv
sed "s#:number##g" -i /$OUTPUTDIR/$INDEXNAME.csv

if [ -s /$OUTPUTDIR/$INDEXNAME.csv ]
then
	curl -XPOST 'http://$RW_USERNAME:$RW_PASSWORD@elasticsearch:9200/$INDEXNAME/logs/_delete_by_query?conflicts=proceed&pretty' -d'{ "query": { "match_all": {} } }'
	node /root/ingest.js
else
    echo "File empty"
fi
