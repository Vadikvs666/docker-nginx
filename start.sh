#!/bin/bash


service mysql start
service php7.0-fpm start
service nginx stop
mysql -u root < /usr/share/zoneminder/db/zm_create.sql
mysql -u root -e "grant insert,select,update,delete,lock tables,alter on zm.* to 'zmuser'@'localhost' identified by 'zmpass';"
service zoneminder start
exec nginx -g 'daemon off;' "$@"
