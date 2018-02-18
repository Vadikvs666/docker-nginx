#name of container: zoneminder-nginx
#versison of container: 0.0.1
FROM debian:jessie 
MAINTAINER Vadim Vagin "vadikvs666@gmail.com"
ENV TZ Asia/Omsk
ENV PORT 8080
RUN echo "deb http://httpredir.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive  apt-get update
RUN DEBIAN_FRONTEND=noninteractive  apt-get install -y mysql-server mysql-client zoneminder nginx-extras fcgiwrap  nginx php5-fpm                            
RUN DEBIAN_FRONTEND=noninteractive  apt-get install -y ffmpeg
RUN DEBIAN_FRONTEND=noninteractive  apt-get clean  
COPY zm.conf /etc/nginx/sites-available/zoneminder
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/zoneminder /etc/nginx/sites-enabled/zoneminder
RUN chown www-data:www-data /etc/zm/zm.conf
RUN chgrp -c www-data /etc/zm/zm.conf
RUN sed  -i "s|\;date.timezone =|date.timezone = \"${TZ:-Asia/Omsk}\"|" /etc/php5/fpm/php.ini
RUN sed -i "s/8080/"$PORT"/1" /etc/nginx/sites-available/zoneminder
VOLUME /var/lib/mysql /var/cache/zoneminder
COPY start.sh /etc/start.sh
CMD ["/etc/start.sh"]
