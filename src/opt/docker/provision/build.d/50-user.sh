#!/usr/bin/env bash

groupmod -n "$APPLICATION_GROUP" `id -gn "$APPLICATION_GID"`
usermod -l "$APPLICATION_USER" -g "$APPLICATION_GID" $(getent passwd "$APPLICATION_UID" | cut -d: -f1)
mkdir -p /home/"$APPLICATION_USER"
chown -h "$APPLICATION_UID":"$APPLICATION_GID" /home/"$APPLICATION_USER"
usermod -d /home/"$APPLICATION_USER" "$APPLICATION_USER"
