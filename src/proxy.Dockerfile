# docker build -t xampp/proxy -f src/proxy.Dockerfile .
# docker run -d --hostname proxy --name proxy --network local -v /var/run/docker.sock:/var/run/docker.sock -p 80:80 -p 443:443 xampp/proxy
FROM traefik:2.0
