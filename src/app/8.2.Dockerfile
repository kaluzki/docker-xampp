# docker build -t xampp/app:8.2 src/app -t xampp/app -f src/app/8.2.Dockerfile
# docker run --rm -ti xampp/app bash

# Distributor ID: Debian
# Description: Debian GNU/Linux 10 (buster)
# Release: 10
# Codename:	buster
FROM webdevops/php-apache-dev:8.2

ENV APPLICATION_USER app
ENV APPLICATION_GROUP app

COPY opt/docker/ /opt/docker/
RUN set -x \
    && docker-php-ext-enable \
       memcached \
       apcu \
       vips \
       redis \
       mongodb \
    &&  docker-run-bootstrap \
    &&  docker-image-cleanup

USER ${APPLICATION_USER}:${APPLICATION_GROUP}
