# Use an outdated base image with known vulnerabilities
FROM ubuntu:16.04

# Install outdated and vulnerable software
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    openssh-server \
    vsftpd \
    php5.6 \
    mysql-server-5.5 \
    && rm -rf /var/lib/apt/lists/*

# Set up a vulnerable web application
COPY vulnerable-app /var/www/html/vulnerable-app
RUN chown -R www-data:www-data /var/www/html/vulnerable-app

# Set up weak credentials for SSH and MySQL
RUN echo 'root:password' | chpasswd
RUN service mysql start && \
    mysql -e "CREATE DATABASE vulnerable_db;" && \
    mysql -e "CREATE USER 'vulnerable_user'@'localhost' IDENTIFIED BY 'weakpassword';" && \
    mysql -e "GRANT ALL PRIVILEGES ON vulnerable_db.* TO 'vulnerable_user'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# Expose vulnerable services
EXPOSE 22 80 21

# Start vulnerable services
CMD service ssh start && service apache2 start && service vsftpd start && service mysql start && tail -f /dev/null