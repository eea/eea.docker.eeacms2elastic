#!/bin/bash

set -e
NODE_TLS_REJECT_UNAUTHORIZED=0

elasticdump --input=KIBANACONFIGURATIONDIR/configurationKibana/INDEXNAME/kibana_mapping.json --output=https://LOGSTASH_RW_USERNAME:LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana
elasticdump --input=KIBANACONFIGURATIONDIR/configurationKibana/INDEXNAME/kibana_analyzer.json --output=https://LOGSTASH_RW_USERNAME:LOGSTASH_RW_PASSWORD@elasticsearch:9200/kibana
elasticdump --input=KIBANACONFIGURATIONDIR/configurationKibana/INDEXNAME/kibana_data.json --output=https://LOGSTASH_RW_USERNAME:LOGSTASH_RW_PASSWORD@elasticsearch:9200/.kibana

