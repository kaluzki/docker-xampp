# docker build src/dosbox -f src/dosbox/Dockerfile -t xampp/dosbox
# docker run --rm -ti xampp/doxbox bash

ARG from=debian:trixie-slim
FROM ${from}
LABEL org.opencontainers.image.authors="Demjan Kaluzki"
LABEL org.opencontainers.image.source="https://github.com/kaluzki/docker-xampp/tree/main/src/dosbox/Dockerfile"

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    set -eux
    echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list.d/unstable.list
    apt-get update
    apt-get install -y --no-install-recommends \
        curl \
        dosbox \
        dosbox-x \
        x11-apps \
        pulseaudio-utils
EOF

COPY --from=xampp/base /etc/bash.bashrc /etc/bash.bashrc
COPY --from=xampp/base /etc/bashrc.d/ /etc/bashrc.d/

ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/run/user/1000
ENV PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native

RUN <<EOF
    groupadd -g 1000 app
    useradd -u 1000 -g 1000 -m -s /bin/bash -k /dev/null app
    usermod -aG audio app
EOF

USER app

COPY --chown=app:app <<EOF /home/app/.config/pulse/.gitkeep
EOF

COPY --chown=app:app <<EOF /home/app/.dosbox/dosbox-0.74-3.conf
[sdl]
output=overlay
autolock=false
windowresolution=1600x900

[midi]
mididevice=none

[dos]
keyboardlayout=gr
EOF

WORKDIR /app
