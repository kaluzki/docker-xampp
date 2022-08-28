#!/usr/bin/env bash

apt-install bash-completion

cat <<EOF >> /etc/bash.bashrc
    for bash_script in /opt/docker/etc/bash.d/*.sh; do
      . "\$bash_script"
    done
    unset bash_script
EOF

