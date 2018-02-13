#name of container: zoneminder-nginx
#versison of container: 0.0.1
FROM ubuntu:14.04 
MAINTAINER Vadim Vagin "vadikvs666@gmail.com"
ENV TZ Asia/Omsk
ENV PORT 8080
RUN add-apt-repository ppa:iconnor/zoneminder \
    && echo $TZ > /etc/timezone && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y zoneminder ffmpeg nginx php5-fpm \
                    && apt-get clean
RUN service apache2 stop
COPY zm.conf /etc/nginx/sites-available/zoneminder
RUN ln -s /etc/nginx/sites-available/zoneminder /etc/nginx/sites-enabled/zoneminder
RUN mysql -uroot  < /usr/share/zoneminder/db/zm_create.sql
RUN mysql -uroot  -e "grant select,insert,update,delete,create,alter,index,lock tables on zm.* to 'zmuser'@localhost identified by 'zmpass';"
RUN chown www-data:www-data /etc/zm/zm.conf
RUN sed  -i "s|\;date.timezone =|date.timezone = \"${TZ:-Asia/Omsk}\"|" /etc/php5/fpm/php.ini
RUN sed 's/8080/${PORT} 8080/1' /etc/nginx/sites-available/zoneminder
RUN Service nginx restart
VOLUME /var/lib/mysql /var/cache/zoneminder
EXPOSE $PORT
