# docker build -t xampp/mysql src -f src/mysql.Dockerfile
# docker run -d --hostname mysql --name mysql --network local -v mysql:/var/lib/mysql xampp/mysql
FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD=root
