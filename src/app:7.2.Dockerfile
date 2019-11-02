# docker build -t xampp/app:7.2 src -f src/app:7.2.Dockerfile
# bin/xampp-up :7.2 --env DOCKER_XAMPP_BIN_ENV=dev

FROM webdevops/php-apache-dev:7.2
# Distributor ID:	Debian
# Description:	Debian GNU/Linux 9.11 (stretch)
# Release:	9.11
# Codename:	stretch

LABEL traefik.enable=true
LABEL traefik.docker.network=local

ENV DOCKER_XAMPP_BIN_ENV prod

ENV APPLICATION_USER app
ENV APPLICATION_GROUP app

ENV POSTFIX_RELAYHOST mail:1025
ENV PHP_SENDMAIL_PATH /usr/sbin/sendmail -t -i
ENV XDEBUG_CONFIG idekey=phpstorm
ENV PHP_IDE_CONFIG serverName=app
ENV COMPOSER_ALLOW_XDEBUG 1
ENV XDEBUG_REMOTE_HOST 172.17.0.1
ENV XDEBUG_PROFILER_ENABLE_TRIGGER 1
ENV WEB_ALIAS_DOMAIN *.localhost
ENV WEB_DOCUMENT_ROOT /app
ENV php.session.gc_maxlifetime 864000
ENV php.session.gc_divisor 1000
ENV php.session.cache_expire 180

COPY opt/docker/ /opt/docker/

RUN set -x \
    &&  docker-run-bootstrap \
    &&  docker-image-cleanup

WORKDIR /app

USER ${APPLICATION_USER}:${APPLICATION_GROUP}
