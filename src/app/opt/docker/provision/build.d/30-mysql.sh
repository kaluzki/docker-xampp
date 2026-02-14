#!/usr/bin/env bash

case $(docker-image-info dist-codename) in
    stretch)
        apt-install mysql-client
        ;;
    buster | bookworm)
        apt-install default-mysql-client
        ;;
esac
