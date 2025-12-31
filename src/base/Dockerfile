# docker build src/base -f src/base/Dockerfile -t xampp/base
# docker run --rm -ti xampp/base bash

ARG from=debian:trixie-slim
FROM ${from}

LABEL org.opencontainers.image.vendor="Demjan Kaluzki"
LABEL org.opencontainers.image.source="https://github.com/kaluzki/docker-xampp/"

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        bash-completion \
        iproute2 \
        curl \
        git \
        ca-certificates
EOF

RUN <<EOF
    set -eux
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
EOF

COPY --from=ghcr.io/netresearch/ofelia /usr/bin/ofelia /usr/local/bin/ofelia
COPY etc /etc

RUN <<EOF cat >> /etc/bash.bashrc
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
[[ -d "/etc/xampp.d" ]] && {
  for script in "/etc/xampp.d/"*.sh; do
    . "\$script"
  done
  unset script
}
EOF

### USER
ARG user=app
ARG uid=1000
RUN <<EOF
    set -eux
    groupadd -g ${uid} ${user}
    useradd -u ${uid} -g ${uid} -m -s /bin/bash -k /dev/null ${user}
EOF

USER ${user}
