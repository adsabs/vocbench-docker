FROM phusion/baseimage

# Install deps
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk tomcat7 libmysql-java wget unzip locales rsync

# Install and setup mysql
ENV LC_ALL C.UTF-8
ENV U root
ENV P fakepassword
RUN echo "mysql-server mysql-server/root_password password $P" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $P" | debconf-set-selections
RUN apt-get install -y mysql-server
ENV U none
ENV P none

# Download and extract vobench
RUN wget https://bitbucket.org/art-uniroma2/vocbench/downloads/VOCBENCH_2.3.zip -O VOCBENCH.zip
RUN mkdir /vocbench && unzip /VOCBENCH.zip -d /vocbench/
RUN unzip -qo /vocbench/semanticturkey-0.11+vb-bundle-2.3.zip -d /vocbench/st-server/
RUN chmod u+x /vocbench/st-server/semanticturkey-0.11/bin/karaf
RUN cp /vocbench/vocbench-2.3.war /var/lib/tomcat7/webapps/vocbench.war
RUN mkdir /var/lib/tomcat7/temp && chown -R tomcat7:tomcat7 /var/lib/tomcat7/temp

#Download and extract open-sesame
RUN mkdir /sesame
RUN wget -O /sesame/sesame-2.7.13.tar.gz http://sourceforge.net/projects/sesame/files/Sesame%202/2.7.13/openrdf-sesame-2.7.13-sdk.tar.gz/download
RUN cd /sesame && tar -xvf /sesame/sesame-2.7.13.tar.gz
RUN cp -r /sesame/openrdf-sesame-2.7.13/war/*war /var/lib/tomcat7/webapps/
RUN mkdir /var/lib/tomcat7/webapps/openrdf-sesame/
RUN cd /var/lib/tomcat7/webapps/openrdf-sesame/ && jar xf ../openrdf-sesame.war
RUN mkdir -p /usr/share/tomcat7/.aduna/logs/

# Add configuration and run scripts
ENV CATALINA_HOME /usr/share/tomcat7
ENV CATALINA_BASE /var/lib/tomcat7
ENV SESAME_DATADIR /usr/share/tomcat7/.aduna/
COPY my.cnf /etc/mysql/my.cnf
COPY tomcat.sh /etc/service/tomcat/run
COPY mysql.sh /etc/service/mysql/run
COPY st_server.sh /etc/service/st_server/run
COPY tomcat-users.xml /var/lib/tomcat7/conf/tomcat-users.xml
COPY web.xml /var/lib/tomcat7/webapps/openrdf-sesame/WEB-INF/web.xml
RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7


EXPOSE 8080

#Supervisord will take care of keeping services up
CMD ["/sbin/my_init"]
