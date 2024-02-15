# docker build -t xampp/app:7.4 -f src/app/7.4.Dockerfile
# docker run --rm -ti xampp/app:7.4 bash

# Distributor ID: Debian
# Description: Debian GNU/Linux 10 (buster)
# Release: 10
# Codename:	buster
FROM webdevops/php-apache-dev:7.4

ENV APPLICATION_USER app
ENV APPLICATION_GROUP app

COPY opt/docker/ /opt/docker/
RUN set -x \
    &&  docker-run-bootstrap \
    &&  docker-image-cleanup

USER ${APPLICATION_USER}:${APPLICATION_GROUP}
