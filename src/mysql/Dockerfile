# docker build -t xampp/mysql src/mysql
# docker run -d --hostname mysql --name mysql --network local -v mysql:/var/lib/mysql xampp/mysql
FROM mysql:5.7

COPY etc/conf.d /etc/mysql/conf.d/
