# docker build docker/php -f docker/php/Dockerfile -t xampp/php:8.5 -t xampp/php
# docker build docker/php -f docker/php/Dockerfile -t xampp/php:8.4 --build-arg from=php:8.4-fpm
# docker build docker/php -f docker/php/Dockerfile -t xampp/php:7.4 --build-arg from=php:7.4-fpm
# docker run --rm -ti xampp/php:7.4 bash

ARG from=php:8.5-fpm
FROM ${from}

COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

ARG TZ=Europe/Berlin
ENV TZ=${TZ}

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    --mount=type=cache,target=/tmp/pear,sharing=locked
    set -eux

    apt-get update
    apt-get install -y --no-install-recommends \
        bash-completion \
        tzdata
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

    export IPE_KEEP_SYSPKG_CACHE=1
    export IPE_ASPELL_LANGUAGES='en de'
    install-php-extensions \
        @composer \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        gnupg \
        imagick \
        imap \
        intl \
        ldap \
        mcrypt \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        pspell \
        redis \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        tidy \
        xsl \
        yaml \
        zip

    export IPE_DONT_ENABLE=1
    install-php-extensions \
      xdebug
EOF

### COPY
COPY --from=xampp/base /etc/bash.bashrc /etc/bash.bashrc
COPY --from=xampp/base /etc/xampp.d/ /etc/xampp.d/
COPY --from=xampp/base /etc/gitconfig /etc/gitconfig
COPY --from=xampp/base /usr/local/bin/starship /usr/local/bin/starship
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

### PHP
RUN <<EOF
    set -eux
    mv /usr/local/bin/php /usr/local/bin/php-prod
    cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
EOF

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
exec php-prod -c /usr/local/etc/php/php.ini-development -d zend_extension=$(php-config --extension-dir)/xdebug.so "\$@"
EOF

COPY <<EOF /usr/local/etc/php/conf.d/zz-xampp.ini
### misc
max_input_vars = 1500
memory_limit = 512M
post_max_size = 32M
upload_max_filesize = 32M
date.timezone = ${TZ}
short_open_tag = On

### opcache
opcache.enable_cli=1

### xdebug
xdebug.mode=debug,develop
xdebug.start_with_request=trigger
xdebug.log_level=0
xdebug.connect_timeout_ms=50
xdebug.discover_client_host=yes
xdebug.client_host=host.docker.internal
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
exec php-fpm-prod -c /usr/local/etc/php/php.ini-development -d zend_extension=$(php-config --extension-dir)/xdebug.so "\$@"
EOF

USER ${user}
WORKDIR /app
ENV PHP_IDE_CONFIG="serverName=app.localhost"
