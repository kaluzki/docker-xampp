#!/usr/bin/env bash

if [[ -n "$DOCKER_XAMPP_CRON" ]]; then
    echo "$DOCKER_XAMPP_CRON" >> /etc/crontab
    echo '' >> /etc/crontab
fi
