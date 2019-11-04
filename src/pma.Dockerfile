# docker build -t xampp/pma src -f src/pma.Dockerfile
# docker run -d --hostname pma --name pma --network local xampp/pma
FROM phpmyadmin/phpmyadmin

ENV PMA_ARBITRARY=1

LABEL traefik.http.routers.pma.middlewares=https-redirect@docker
LABEL traefik.http.routers.pma.rule=Host(`pma.localhost`)
LABEL traefik.http.routers.pma.tls=true
LABEL traefik.enable=true
