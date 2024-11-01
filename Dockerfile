FROM debian:buster

ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress_user
ENV MYSQL_PASSWORD=wordpress_password
# dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    php-mbstring \
    php-zip \
    php-gd \
    php-curl \
    php-xml \
    mariadb-server \
    curl \
    && apt-get clean

# MySQL
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE ${MYSQL_DATABASE};" && \
    mysql -u root -e "CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';" && \
    mysql -u root -e "FLUSH PRIVILEGES;"

# WordPress
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -zxvf latest.tar.gz \
    && mv wordpress /var/www/html/ \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/html/wordpress

# phpMyAdmin
RUN curl -o phpMyAdmin.tar.gz -L https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz \
    && tar -zxvf phpMyAdmin.tar.gz \
    && mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin \
    && rm phpMyAdmin.tar.gz \
    && chown -R www-data:www-data /var/www/html/phpmyadmin

# custom index page
COPY index.php /var/www/html/index.php

# config Apache
COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

EXPOSE 80

CMD service mysql start && apache2ctl -D FOREGROUND
