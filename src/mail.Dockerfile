# docker build -t xampp/mail src -f src/mail.Dockerfile
# docker run -d --hostname mail --name mail --network local xampp/mail
FROM mailhog/mailhog

LABEL traefik.http.routers.mail.middlewares=https-redirect@docker
LABEL traefik.http.routers.mail.rule=Host(`mail.localhost`)
LABEL traefik.http.routers.mail.tls=true
LABEL traefik.http.services.mail.loadbalancer.server.port=8025
LABEL traefik.enable=true
