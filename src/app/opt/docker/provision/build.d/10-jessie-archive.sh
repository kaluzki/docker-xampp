#!/usr/bin/env bash
# https://superuser.com/a/1417656/1020795

if [[ $(docker-image-info dist-codename) = "jessie" ]]; then
cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian/ jessie main contrib non-free
deb http://security.debian.org/ jessie/updates main contrib non-free
EOF
fi
