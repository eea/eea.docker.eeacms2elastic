FROM alpine

RUN apk add --update git unzip openntpd openjdk8-jre bash nodejs curl git nodejs-npm

#FROM node:6.12.0

WORKDIR /opt

#RUN apt-get update -y
#RUN apt-get install -y vim openntpd wget curl git cron cronutils 

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
