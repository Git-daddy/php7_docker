FROM php:7.1-fpm

#install Imagemagick & PHP Imagick ext
#RUN apt-get update && apt-get install -y \
#       libmagickwand-dev git zlib1g-dev --no-install-recommends

#RUN docker-php-ext-install pdo_mysql mbstring mysqli pdo zip

#RUN pecl install xdebug && docker-php-ext-enable xdebug

#RUN pecl install imagick && docker-php-ext-enable imagick



# Install PHP extensions
RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        autoconf \
        bzip2-dev \
    ; \
    \
    docker-php-ext-install \
        bz2 \
        mbstring \
        mysqli \
        pdo_mysql \
        opcache \
    ; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )"; \
    apk add --virtual .phpext-rundeps $runDeps; \
    apk del .build-deps


COPY conf/php.ini /usr/local/etc/php/conf.d/40-custom.ini

# Install composer
COPY --from=composer:1.6.5 /usr/bin/composer /usr/bin/composer

COPY conf/my.cnf /etc/mysql/my.cnf

#CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
