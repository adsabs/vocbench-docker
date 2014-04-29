FROM debian

	#Install deps
RUN apt-get update && apt-get install -y fakeroot locales
RUN apt-get install -y openjdk-7-jdk tomcat7 libmysql-java wget unzip nano cron rsync
RUN apt-get install -y supervisor

#run_server.sh has DOS line endings that make it unusuable
RUN apt-get install dos2unix

ENV LC_ALL C.UTF-8
ENV U root
ENV P fakepassword

RUN echo "mysql-server mysql-server/root_password password $P" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $P" | debconf-set-selections
RUN apt-get install -y mysql-server

#Java needs access to host's /dev/fuse in a postinit script.
#Must use fakeroot if we don't want to give container access to hosts /dev/
RUN fakeroot apt-get install -y openjdk-7-jdk

	#Download+extract vobench
RUN wget https://bitbucket.org/art-uniroma2/vocbench/downloads/VOCBENCH_2.1.zip
RUN mkdir /vocbench && unzip /VOCBENCH_2.1.zip -d /vocbench/
RUN unzip /vocbench/st-server.zip -d /vocbench/
RUN dos2unix /vocbench/st-server/server_run.sh
RUN cp /vocbench/vocbench.war /var/lib/tomcat7/webapps/vocbench#vocbench-2.1.war

	#Setup backup
ADD checkdata.sh /checkdata.sh

ENV U none
ENV P none

EXPOSE 8080

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD my.cnf /etc/mysql/my.cnf
CMD ["/usr/bin/supervisord"]
