# docker build -t xampp/dns src -f src/dns.Dockerfile
# docker run -d --hostname dns --name dns --network local -v /var/run/docker.sock:/var/run/docker.sock -v /etc/resolv.conf:/etc/resolv.conf xampp/dns
FROM defreitas/dns-proxy-server:2.18.1

LABEL traefik.http.routers.dns.middlewares=https-redirect@docker
LABEL traefik.http.routers.dns.rule=Host(`dns.localhost`)
LABEL traefik.http.routers.dns.tls=true
LABEL traefik.http.services.dns.loadbalancer.server.port=5380
LABEL traefik.enable=true

ENV MG_REGISTER_CONTAINER_NAMES 1
ENV MG_DOMAIN ".localhost"
ENV MG_HOST_MACHINE_HOSTNAME "host.localhost"
