#!/bin/bash

MYSQL_DATADIR="/data/"
ST_DATADIR="/vocbench/st-server/semanticturkey-0.10.1/bin"

service tomcat7 restart
if [ ! "$(ls -A $MYSQL_DATADIR)" ]; then
  rsync -a /var/lib/mysql/* $MYSQL_DATADIR
  touch $MYSQL_DATADIR.initialized_by_checkdata_sh
  chown -R mysql:mysql /data
fi
service mysql restart

pushd $ST_DATADIR
bash start
popd
