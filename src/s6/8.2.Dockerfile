# docker build -t xampp/app:8.2 src/app -f src/app/8.2.Dockerfile
# docker run -t xampp/app:8.2 src/app -f src/app/8.2.Dockerfile

FROM php:8.2-fpm-bullseye
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends apache2 ; \
    a2enmod actions proxy proxy_fcgi ssl rewrite headers expires; \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ENTRYPOINT ["/init"]