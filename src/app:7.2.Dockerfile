# docker build -t xampp/app:7.2 src -f src/app:7.2.Dockerfile
# bin/xampp-app :7.2 --env DOCKER_XAMPP_BIN_ENV=dev

# Distributor ID:	Debian
# Description:	Debian GNU/Linux 9.11 (stretch)
# Release:	9.11
# Codename:	stretch
FROM webdevops/php-apache-dev:7.2

ENV APPLICATION_USER app
ENV APPLICATION_GROUP app

COPY opt/docker/ /opt/docker/
RUN set -x \
    &&  docker-run-bootstrap \
    &&  docker-image-cleanup

USER ${APPLICATION_USER}:${APPLICATION_GROUP}

