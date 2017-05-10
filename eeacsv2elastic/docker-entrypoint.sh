#!/bin/bash

set -e

if [ "$RW_USERNAME" ]; then
    sed "s#RW_USERNAME#$RW_USERNAME#g" -i /opt/ingest.js
    sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /opt/ingest.js
    sed "s#RW_USERNAME#$RW_USERNAME#g" -i /opt/script.sh
    sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /opt/script.sh
    sed "s#RW_USERNAME#$RW_USERNAME#g" -i /opt/ingestKibana.sh
    sed "s#RW_PASSWORD#$RW_PASSWORD#g" -i /opt/ingestKibana.sh
fi

sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/ingest.js
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /opt/ingest.js
sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/script.sh
sed "s#OUTPUTDIR#$OUTPUTDIR#g" -i /opt/script.sh

sed "s#DOWNLOADURL#$DOWNLOADURL#g" -i /opt/script.sh

sed "s#KIBANACONFIGURATIONDIR#$KIBANACONFIGURATIONDIR#g" -i /opt/script.sh
sed "s#KIBANACONFIGURATIONDIR#$KIBANACONFIGURATIONDIR#g" -i /opt/ingestKibana.sh
sed "s#INDEXNAME#$INDEXNAME#g" -i /opt/ingestKibana.sh

if [ "$RESETATSTARTUP" = "YES" ] && [ -d "$KIBANACONFIGURATIONDIR/configurationKibana" ];
then
    cd $KIBANACONFIGURATIONDIR/configurationKibana 
    git pull
#    rm -rf $KIBANACONFIGURATIONDIR
fi

if [ ! -d "$KIBANACONFIGURATIONDIR/configurationKibana" ]
then
  git clone https://github.com/eea/eea.kibana.configs.git $KIBANACONFIGURATIONDIR/configurationKibana
  cd $KIBANACONFIGURATIONDIR/configurationKibana/$INDEXNAME
#  git checkout $INDEXNAME
fi

#ls $KIBANACONFIGURATIONDIR/$INDEXNAME

sleep 30

sh /opt/ingestKibana.sh
sh /opt/script.sh

exec "$@" 

