# docker build -t xampp/mail src -f src/mail.Dockerfile
# docker run -d --hostname mail --name mail --network local xampp/mail
FROM mailhog/mailhog

LABEL traefik.enable=true
LABEL traefik.port=8025
LABEL traefik.frontend.rule=Host:mail.localhost
LABEL traefik.docker.network=local
