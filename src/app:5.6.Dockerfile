# docker build -t xampp/app:5.6 src -f src/app:5.6.Dockerfile
# bin/xampp-app dev:5.6 --env DOCKER_XAMPP_BIN_ENV=dev

# Distributor ID:	Debian
# Description:	Debian GNU/Linux 8.11 (jessie)
# Release:	8.11
# Codename:	jessie
FROM webdevops/php-apache-dev:debian-8

ENV APPLICATION_USER app
ENV APPLICATION_GROUP app

COPY opt/docker/ /opt/docker/
RUN set -x \
    &&  docker-run-bootstrap \
    &&  docker-image-cleanup

USER ${APPLICATION_USER}:${APPLICATION_GROUP}
