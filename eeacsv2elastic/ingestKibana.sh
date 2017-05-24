#!/bin/bash

set -e

if [ -d "/configurationKibana/INDEXNAME" ];
then
  elasticdump --input=/configurationKibana/INDEXNAME/kibana_mapping.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana
  elasticdump --input=/configurationKibana/INDEXNAME/kibana_analyzer.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/kibana
  elasticdump --input=/configurationKibana/INDEXNAME/kibana_data.json --output=http://RW_USERNAME:RW_PASSWORD@elasticsearch:9200/.kibana
fi
