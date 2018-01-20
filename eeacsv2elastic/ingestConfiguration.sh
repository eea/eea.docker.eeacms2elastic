#!/bin/bash

set -e
NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --type=mapping --output-index=.kibana --headers='{"Content-Type": "application/json"}' --input=/eea.kibana.configs/$INDEXNAME/kibana_mapping.json --output=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200
NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --type=analyzer --output-index=.kibana --headers='{"Content-Type": "application/json"}' --input=/eea.kibana.configs/$INDEXNAME/kibana_analyzer.json --output=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200
NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --type=data --output-index=.kibana --headers='{"Content-Type": "application/json"}' --input=/eea.kibana.configs/$INDEXNAME/kibana_data.json --output=https://$LOGSTASH_RW_USERNAME:$LOGSTASH_RW_PASSWORD@elasticsearch:9200