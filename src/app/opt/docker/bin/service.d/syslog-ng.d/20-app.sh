#!/usr/bin/env bash

DOCKER_XAMPP_LOG="${DOCKER_XAMPP_LOG:-/var/log/app}"
touch ${DOCKER_XAMPP_LOG}
chown -h "$APPLICATION_UID":"$APPLICATION_GID" ${DOCKER_XAMPP_LOG}
echo "source app {file('${DOCKER_XAMPP_LOG}' flags(no-parse));};" >> /etc/syslog-ng/syslog-ng.conf
echo 'log {source(app); destination(d_all);};' >> /etc/syslog-ng/syslog-ng.conf
