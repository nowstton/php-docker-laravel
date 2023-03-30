ARG IMG_DB_VERSION=latest
FROM php-docker-setup-webserver_service:${IMG_DB_VERSION}

LABEL MAINTAINER="https://github.com/nowstton"

ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME
ARG USERID

ENV USERNAME ${USERNAME}
ENV USERID ${USERID}

COPY .docker/scripts/before-start.sh /usr/bin/before-start

RUN apt-get update && apt-get -f -y install php8.2-xdebug \
  && apt-get clean \
  && rm -Rrf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && phpdismod xdebug \
  && chmod +x /usr/bin/reload-permissions \
  && chmod +x /usr/bin/before-start \
  && sed -i 's/.*PHP_VALUE.*/fastcgi_param PHP_VALUE "xdebug.mode=debug xdebug.start_with_request=trigger xdebug.client_port=9003 xdebug.discover_client_host=true";/' /etc/nginx/conf.d/default.conf

COPY .docker/services/webservice/php/extensions/xdebug.ini /etc/php/${PHP_VERSION}/mods-available/xdebug.ini

RUN phpenmod xdebug; \
  useradd -U -G www-data,root -u ${USERID} \
  -d /home/${USERNAME} ${USERNAME} -ms /bin/bash; \
  mkdir -p /home/${USERNAME}/.composer \
  && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

EXPOSE 80
EXPOSE 9003
