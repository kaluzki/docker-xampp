#!/usr/bin/env bash

case $(docker-image-info dist-codename) in
    stretch)
        apt-install mysql-client
        ;;
    buster)
        apt-install default-mysql-client
        ;;
esac
