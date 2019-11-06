# docker build -t xampp/pma src -f src/pma.Dockerfile
# docker run -d --hostname pma --name pma --network local xampp/pma
FROM phpmyadmin/phpmyadmin
