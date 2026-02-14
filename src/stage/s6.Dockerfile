# docker build -t xampp/s6 -t xampp/s6:3.1.1.2 --build-arg S6=3.1.1.2 src/stage -f src/stage/s6.Dockerfile
# docker build -t xampp/s6:3.1.1.1 --build-arg S6=3.1.1.1 src/stage -f src/stage/s6.Dockerfile

FROM debian:bullseye-slim as build
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends xz-utils ; \
    rm -rf /var/lib/apt/lists/*

ARG S6=3.1.1.2

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6}/s6-overlay-x86_64.tar.xz /tmp

RUN set -eux; \
    mkdir /s6 -p; \
    tar -C /s6 -Jxpf /tmp/s6-overlay-noarch.tar.xz; \
    tar -C /s6 -Jxpf /tmp/s6-overlay-x86_64.tar.xz

FROM scratch
COPY --from=build /s6 /