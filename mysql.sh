#!/bin/bash
MYSQL_DATADIR="/data"
if [ ! "$(ls -A $MYSQL_DATADIR)" ]; then
  rsync -a /var/lib/mysql/* $MYSQL_DATADIR
  chown -R mysql:mysql /data
fi
/usr/bin/mysqld_safe
