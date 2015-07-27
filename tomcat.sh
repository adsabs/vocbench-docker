#!/bin/bash
chown -R tomcat7:tomcat7 $SESAME_DATADIR
/sbin/setuser tomcat7 /usr/share/tomcat7/bin/catalina.sh run
