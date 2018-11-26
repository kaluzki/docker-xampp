# docker build -t xampp/pma src -f src/pma.Dockerfile
# docker run -d --hostname pma --name pma --network local xampp/pma
FROM phpmyadmin/phpmyadmin

ENV PMA_ARBITRARY=1

LABEL traefik.enable=true
LABEL traefik.docker.network=local
LABEL traefik.frontend.rule=Host:pma.localhost
