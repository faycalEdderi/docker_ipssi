FROM debian:buster

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

# MySQL conf
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE wordpress;" && \
    mysql -u root -e "CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'wordpress_password';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'localhost';" && \
    mysql -u root -e "FLUSH PRIVILEGES;"

# WordPress install
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -zxvf latest.tar.gz \
    && mv wordpress/* /var/www/html/ \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/html/

# phpMyAdmin install
RUN curl -o phpMyAdmin.tar.gz -L https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz \
    && tar -zxvf phpMyAdmin.tar.gz \
    && mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin \
    && rm phpMyAdmin.tar.gz \
    && chown -R www-data:www-data /var/www/html/phpmyadmin

# Apache configuration
COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

EXPOSE 80

CMD service mysql start && apache2ctl -D FOREGROUND
