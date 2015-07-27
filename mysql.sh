#!/bin/bash
MYSQL_DATADIR="/data"
if [ ! "$(ls -A $MYSQL_DATADIR)" ]; then
  rsync -a /var/lib/mysql/* $MYSQL_DATADIR
fi
chown -R mysql:mysql /data
/usr/bin/mysqld_safe
