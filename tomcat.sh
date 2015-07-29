#!/bin/bash
sleep 5 # Lovely hack to run this "patch" at runtime, since mysql should already be up
pushd /validation_patch
java -jar /validation_patch/vocbench-patch-2.3.jar
popd
chown -R tomcat7:tomcat7 $SESAME_DATADIR
/sbin/setuser tomcat7 /usr/share/tomcat7/bin/catalina.sh run
