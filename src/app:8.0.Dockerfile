# docker build -t xampp/app:8.0 src -f src/app:8.0.Dockerfile
# bin/xampp-app :8.0 --env DOCKER_XAMPP_BIN_ENV=dev

# Distributor ID:	Debian
# Description:	Debian GNU/Linux 10 (buster)
# Release:	10
# Codename:	buster
FROM webdevops/php-apache-dev:8.0

ENV APPLICATION_USER app
ENV APPLICATION_GROUP app

COPY opt/docker/ /opt/docker/
RUN set -x \
    &&  docker-run-bootstrap \
    &&  docker-image-cleanup

USER ${APPLICATION_USER}:${APPLICATION_GROUP}
