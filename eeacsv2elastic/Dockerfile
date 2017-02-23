FROM alpine

RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update openntpd bash wget moreutils nodejs curl


COPY script.sh /opt/script.sh
RUN chmod a+x /opt/script.sh 

RUN mkdir -p /var/spool/cron/crontabs
COPY ingest.js /root

RUN npm install elasticsearch-csv

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ntpd -p pool.ntp.org && echo "$CRON_ENTRY" /opt/script.sh | crontab - && crond -f
