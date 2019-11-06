# docker build -t xampp/mail src -f src/mail.Dockerfile
# docker run -d --hostname mail --name mail --network local xampp/mail
FROM mailhog/mailhog
