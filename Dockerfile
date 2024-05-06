FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update \
#     && apt-get install -y gnupg tzdata \
#     && echo "UTC" ? "/etc/timezone" \
#     && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update \
    && apt-get install -y curl zip unzip git supervisor \
       nginx php7.2-fpm php7.2-cli php7.2-curl \
       php7.2-mysql php7.2-mbstring php7.2-xml \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

ADD nginx.conf /etc/nginx/sites-available/default.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD initial.sh /usr/bin/initial
RUN chmod +x /usr/bin/initial

ENTRYPOINT [ "initial" ]
