# https://hub.docker.com/_/php
ARG  PHP_VERSION
FROM php:${PHP_VERSION}-apache

RUN apt update && apt install -y zlib1g-dev libpng-dev libzip-dev libxml2-dev libonig-dev \
		libfreetype-dev \
		libjpeg62-turbo-dev libgd-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install gd
RUN docker-php-ext-configure mysqli && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure xml && \
    docker-php-ext-configure mbstring && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure intl 
RUN docker-php-ext-install mysqli pdo_mysql zip xml mbstring opcache intl

COPY src /var/www/html
RUN chown -R www-data: /var/www/html/personnalisation/images
RUN chown -R www-data: /var/www/html/temp
#RUN chown -R www-data: themes/default/css/types.css

# the 0 group must be able to read
RUN chgrp -R 0 /var/www/html
RUN chmod -R g+rx /var/www/html
# Does the container need to write somewhere ?
RUN chmod -R g+w /var/www/html/personnalisation /var/www/html/temp



# copy connect template
COPY connect.inc.php /var/www/html/personnalisation/connect.inc.php.template

# copy script db_config
COPY ./scripts/db_config.sh /usr/local/bin/db_config.sh
RUN chmod +x /usr/local/bin/db_config.sh
ENTRYPOINT [ "/usr/local/bin/db_config.sh" ]



RUN rm -rf /var/www/html/installation


RUN echo "Listen 8080" > /etc/apache2/ports.conf


# a random user, for security
USER 1001
# is also member of group 0
WORKDIR /var/www/html

EXPOSE 8080
CMD ["apache2-foreground"]
