#!/bin/bash

set -e

elasticdump --input=KIBANACONFIGURATIONDIR/configurationKibana/INDEXNAME/kibana_mapping.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana
elasticdump --input=KIBANACONFIGURATIONDIR/configurationKibana/INDEXNAME/kibana_analyzer.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/kibana
elasticdump --input=KIBANACONFIGURATIONDIR/configurationKibana/INDEXNAME/kibana_data.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana

#elasticdump --input=KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_mapping.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME
#elasticdump --input=KIBANACONFIGURATIONDIR/INDEXNAME/INDEXNAME_analyzer.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME
#elasticdump --input=KIBANACONFIGURATIONDIR/INDEXNAME_data.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/INDEXNAME
