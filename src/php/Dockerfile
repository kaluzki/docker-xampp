# docker build src/php -f src/php/Dockerfile -t xampp/php:8.5 -t xampp/php
# docker build src/php -f src/php/Dockerfile -t xampp/php:8.4 --build-arg from=php:8.4-fpm
# docker build src/php -f src/php/Dockerfile -t xampp/php:7.4 --build-arg from=php:7.4-fpm --build-arg xdebug=3.1.6
# docker run --rm -ti xampp/php:7.4 bash

ARG from=php:8.5-fpm
FROM ${from}

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        bash-completion \
        unzip
EOF

ARG xdebug=stable
RUN <<EOF
    set -eux
    docker-php-ext-install \
        pcntl \
        pdo \
        pdo_mysql \
        sockets
    pecl install xdebug-${xdebug}
EOF

### COPY
COPY --from=xampp/base /etc/bash.bashrc /etc/bash.bashrc
COPY --from=xampp/base /etc/xampp.d/ /etc/xampp.d/
COPY --from=xampp/base /etc/gitconfig /etc/gitconfig
COPY --from=xampp/base /usr/local/bin/starship /usr/local/bin/starship
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=ghcr.io/roadrunner-server/roadrunner /usr/bin/rr /usr/local/bin/rr

RUN <<EOF
    set -eux
    composer completion bash > /usr/share/bash-completion/completions/composer
    rr completion bash > /usr/share/bash-completion/completions/rr
EOF

### USER
ARG user=app
ARG uid=1000
RUN <<EOF
    set -eux
    groupadd -g ${uid} ${user}
    useradd -u ${uid} -g ${uid} -m -s /bin/bash -k /dev/null ${user}
EOF

### PHP-FPM
COPY <<EOF /usr/local/etc/php-fpm.d/zz-xampp.conf
[www]
listen=/var/run/php/php-fpm.sock
user=
group=
listen.owner=${user}
listen.group=${user}
EOF

RUN <<EOF
    set -eux
    [ -f /usr/local/sbin/php-fpm ] && mv /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm-prod || true
    mkdir -p /var/run/php
    chown ${user}:${user} /var/run/php
EOF

COPY --chmod=755 <<EOF /usr/local/sbin/php-fpm
#! /bin/sh
set -e
APP_ENV=\${APP_ENV:-prod}
if [ "\$APP_ENV" != "prod" -a "\$APP_ENV" != "production" ]; then
  exec php-fpm-dev "\$@"
else
  exec php-fpm-prod "\$@"
fi
EOF

COPY --chmod=755 <<EOF /usr/local/sbin/php-fpm-dev
#! /bin/sh
set -e
exec php-fpm-prod -d zend_extension=$(php-config --extension-dir)/xdebug.so "\$@"
EOF

### PHP
RUN mv /usr/local/bin/php /usr/local/bin/php-prod

COPY --chmod=755 <<EOF /usr/local/bin/php
#! /bin/sh
set -e
APP_ENV=\${APP_ENV:-prod}
if [ "\$APP_ENV" != "prod" -a "\$APP_ENV" != "production" ]; then
  exec php-dev "\$@"
else
  exec php-prod "\$@"
fi
EOF

COPY --chmod=755 <<EOF /usr/local/bin/php-dev
#! /bin/sh
set -e
export XDEBUG_TRIGGER=1
exec php-prod -d zend_extension=$(php-config --extension-dir)/xdebug.so "\$@"
EOF

COPY <<EOF /usr/local/etc/php/conf.d/xdebug.ini
xdebug.mode=debug,develop
xdebug.start_with_request=trigger
xdebug.log_level=0
xdebug.connect_timeout_ms=50
xdebug.discover_client_host=yes
xdebug.client_host=host.docker.internal
EOF

USER ${user}
WORKDIR /app
ENV PHP_IDE_CONFIG="serverName=app.localhost"
