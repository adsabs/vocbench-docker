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
RUN wget https://bitbucket.org/art-uniroma2/vocbench/downloads/VOCBENCH_2.0.1-SNAPSHOT_2013-11-27.zip
RUN mkdir /vobench && unzip /VOCBENCH_2.0.1-SNAPSHOT_2013-11-27.zip -d /vobench/
RUN unzip /vobench/st-server.zip -d /vobench/
RUN dos2unix /vobench/st-server/server_run.sh
RUN ln -s /vobench/vocbench-2.0.1.war /var/lib/tomcat7/webapps/

	#Setup mysql admin
RUN service mysql start && mysql -u $U -p$P < /vobench/administrator20.sql

	#Setup backup; look into better way of serving datadir from host that has already been set up in the container
#RUN (crontab -u root -l; echo "*/2 * * * * rsync -a /var/lib/mysql/ /data/") | crontab -u root -
ADD checkdata.sh /checkdata.sh

ENV U none
ENV P none

EXPOSE 8080

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD my.cnf /etc/mysql/my.cnf
CMD ["/usr/bin/supervisord"]
