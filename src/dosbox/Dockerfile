# docker build src/dosbox -f src/dosbox/Dockerfile -t xampp/dosbox
# docker run --rm -ti xampp/dosbox bash

FROM xampp/base

USER root

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    set -eux
    echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list.d/unstable.list
    apt-get update
    apt-get install -y --no-install-recommends \
        dosbox \
        dosbox-x \
        x11-apps \
        pulseaudio-utils
EOF

ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/run/user/1000
ENV PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native

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
