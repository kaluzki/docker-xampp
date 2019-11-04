# docker build -t xampp/proxy -f src/proxy.Dockerfile .
# docker run -d --hostname proxy --name proxy --network local -v /var/run/docker.sock:/var/run/docker.sock -p 80:80 -p 443:443 xampp/proxy
FROM traefik:2.0

LABEL traefik.http.middlewares.https-redirect.redirectscheme.scheme=https
LABEL traefik.http.routers.proxy.middlewares=https-redirect@docker
LABEL traefik.http.routers.proxy.rule=Host(`proxy.localhost`)
LABEL traefik.http.routers.proxy.tls=true
LABEL traefik.http.services.proxy.loadbalancer.server.port=8080
LABEL traefik.enable=true

CMD [ \
	"--api=true", \
	"--api.insecure=true", \
	"--log.level=error", \
	"--entrypoints.web.address=:80", \
	"--entrypoints.web-secure.address=:443", \
	"--providers.docker=true", \
	"--providers.docker.network=local", \
	"--providers.docker.exposedByDefault=false" \
]
