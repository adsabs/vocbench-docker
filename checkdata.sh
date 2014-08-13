#!/bin/bash

MYSQL_DATADIR="/data/"
ST_DATADIR="/st-server/"

service tomcat7 restart
if [ ! "$(ls -A $MYSQL_DATADIR)" ]; then
  rsync -a /var/lib/mysql/* $MYSQL_DATADIR
  touch $MYSQL_DATADIR.initialized_by_checkdata_sh
  chown -R mysql:mysql /data
fi
service mysql restart

if [ ! "$(ls -A $ST_DATADIR)" ]; then
  rsync -a /vocbench/st-server/* $ST_DATADIR
  touch $ST_DATADIR.initialized_by_checkdata_sh
fi

pushd $ST_DATADIR
bash server_run.sh
popd
