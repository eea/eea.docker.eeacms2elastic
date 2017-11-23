FROM node:6.12.0-alpine

WORKDIR /opt
RUN npm install elasticsearch-csv
RUN npm install elasticdump -g

RUN mkdir -p /var/spool/cron/crontabs
COPY ingest.js /opt

COPY script.sh /opt/script.sh
RUN chmod a+x /opt/script.sh

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ntpd -p pool.ntp.org && echo "$CRON_ENTRY" /opt/script.sh | crontab - && crond -f
