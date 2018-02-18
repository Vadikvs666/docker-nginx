#!/bin/bash

service mysql start
service php5-fpm start
service nginx stop
# Create the ZoneMinder database
mysql -u root < /usr/share/zoneminder/db/zm_create.sql
# Add the ZoneMinder DB user
mysql -u root -e "grant insert,select,update,delete,lock tables,alter on zm.* to 'zmuser'@'localhost' identified by 'zmpass';"
service zoneminder start
exec nginx -g 'daemon off;' "$@"
