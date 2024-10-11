# https://hub.docker.com/_/php
ARG  PHP_VERSION
FROM php:${PHP_VERSION}-apache

# RUN apk add --no-cache build-base freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev libxml2-dev m4 re2c autoconf libpng libjpeg-turbo freetype libzip
RUN apt update && apt install -y zlib1g-dev libpng-dev libzip-dev libxml2-dev libonig-dev
RUN docker-php-ext-configure gd && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure xml && \
    docker-php-ext-configure mbstring && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure intl 
RUN docker-php-ext-install gd mysqli pdo_mysql zip xml mbstring opcache intl
# RUN apk del build-base freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev libxml2-dev m4 re2c autoconf

#RUN apt update && apt install -y php-gd php-mbstring php-mysql php-xml php-intl

COPY src /var/www/html
RUN chown -R www-data: /var/www/html/personnalisation/images
RUN chown -R www-data: /var/www/html/temp
#RUN chown -R www-data: themes/default/css/types.css

# the 0 group must be able to read
RUN chgrp -R 0 /var/www/html
RUN chmod -R g+rx /var/www/html
RUN chmod -R g+w /var/www/html/personnalisation /var/www/html/temp
#RUN chgrp -R 0 /var/www/html themes/default/css/types.css
#RUN chmod -R g+rx /var/www/html themes/default/css/types.css

# Does the container need to write somewhere ?


#COPY connect.inc.php /var/www/html/include/connect.inc.php
COPY connect.inc.php /var/www/html/personnalisation/connect.inc.php
#COPY config.inc.php /var/www/html/include/config.inc.php
#COPY config_ldap.inc.php /var/www/html/include/config_ldap.inc.php
#RUN chown www-data: /var/www/html/include/config_ldap.inc.php

#COPY php.ini /etc/php/php.ini

RUN rm -rf /var/www/html/installation

COPY ./scripts/db_config.sh /usr/local/bin/db_config.sh
RUN chmod +x /usr/local/bin/db_config.sh

ENTRYPOINT [ "/usr/local/bin/db_config.sh" ]

RUN echo "Listen 8080" > /etc/apache2/ports.conf


# a random user, for security
USER 1001
# is also member of group 0
WORKDIR /var/www/html

EXPOSE 8080
CMD ["apache2-foreground"]
