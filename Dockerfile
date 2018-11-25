FROM php:7.1-fpm

#install Imagemagick & PHP Imagick ext
RUN apt-get update && apt-get install -y \
        libmagickwand-dev git zlib1g-dev libpng-dev --no-install-recommends
RUN docker-php-ext-install pdo_mysql mbstring mysqli pdo zip gd opcache
RUN pecl install xdebug && docker-php-ext-enable xdebug
#RUN pecl install imagick && docker-php-ext-enable imagick
#COPY conf/php.ini /etc/php/7.1/fpm/conf.d/40-custom.ini

COPY conf/php.ini /usr/local/etc/php/conf.d/40-custom.ini
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer
#COPY conf/my.cnf /etc/mysql/my.cnf

#CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
