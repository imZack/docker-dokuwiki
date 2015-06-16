FROM ubuntu:14.04
MAINTAINER YuLun Shih <shih@yulun.me>

RUN apt-get update && \
    apt-get install -y nginx php5-fpm php5-gd php5-ldap curl && \
    rm -rf /var/lib/apt/lists/*

ENV DOKUWIKI_VERSION 2014-09-29d
ENV MD5_CHECKSUM 2bf2d6c242c00e9c97f0647e71583375

RUN mkdir -p /var/www \
    && cd /var/www \
    && curl -O "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" \
    && echo "$MD5_CHECKSUM  dokuwiki-$DOKUWIKI_VERSION.tgz" | md5sum -c - \
    && tar xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 \
    && rm "dokuwiki-$DOKUWIKI_VERSION.tgz"

RUN chown -R www-data:www-data /var/www

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/
RUN mkdir /dokuwiki \
    && ln -s /var/www/data/pages /dokuwiki/data/pages \
    && ln -s /var/www/data/meta /dokuwiki/data/meta \
    && ln -s /var/www/data/media /dokuwiki/data/media \
    && ln -s /var/www/data/media_attic /dokuwiki/data/media_attic \
    && ln -s /var/www/data/media_meta /dokuwiki/data/media_meta \
    && ln -s /var/www/data/attic /dokuwiki/data/attic \
    && ln -s /var/www/conf /dokuwiki/conf \
    && ln -s /var/log /dokuwiki/log


EXPOSE 80
VOLUME /dokuwiki

CMD /usr/sbin/php5-fpm && /usr/sbin/nginx
