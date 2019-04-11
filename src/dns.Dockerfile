# docker build -t xampp/dns src -f src/dns.Dockerfile
# docker run -d --hostname dns --name dns --network local -v /var/run/docker.sock:/var/run/docker.sock -v /etc/resolv.conf:/etc/resolv.conf xampp/dns
FROM defreitas/dns-proxy-server:2.10.4

LABEL traefik.enable=true
LABEL traefik.docker.network=local
LABEL traefik.frontend.rule=Host:dns.localhost
LABEL traefik.port=5380

ENV MG_REGISTER_CONTAINER_NAMES 1
