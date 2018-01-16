FROM alpine

RUN apk add --update git unzip openntpd openjdk8-jre bash nodejs curl git nodejs-npm

WORKDIR /opt

ADD elasticsearch-csv /elasticsearch-csv
RUN cd /elasticsearch-csv && npm install -g

#RUN npm install elasticsearch-csv
RUN npm install elasticdump -g

RUN mkdir -p /var/spool/cron/crontabs
COPY ingest.js /opt

COPY script.sh /opt/script.sh
RUN chmod a+x /opt/script.sh

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ntpd -p pool.ntp.org && echo "$CRON_ENTRY" /opt/script.sh | crontab - && crond -f
