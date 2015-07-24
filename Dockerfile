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

# Add configuration and run scripts
COPY my.cnf /etc/mysql/my.cnf
COPY tomcat.sh /etc/service/tomcat/run
COPY mysql.sh /etc/service/mysql/run
COPY st_server.sh /etc/service/st_server/run

EXPOSE 8080

#Supervisord will take care of keeping services up
CMD ["/sbin/my_init"]
