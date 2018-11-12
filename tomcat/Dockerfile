FROM tomcat
RUN apt-get update && apt-get install curl -y && apt-get install vim -y
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.4-amd64.deb
RUN dpkg -i filebeat-6.2.4-amd64.deb
COPY filebeat.yml /etc/filebeat/
#WORKDIR /usr/local/tomcat/bin
#CMD ["catalina.sh","run"]
