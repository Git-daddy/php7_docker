FROM php:7.3-fpm-alpine

#install Imagemagick & PHP Imagick ext
RUN apk update \
    && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && apk --no-cache add \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        imagemagick \
        bash \
        libxslt-dev \
        pngcrush \
        libzip-dev \
        git \
        icu-dev \
        zip \
        vim
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install \
        bcmath \
        sockets \
        gd \
        soap \
        xsl \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        opcache \
        simplexml \
        intl

RUN pecl install \
    apcu \
    apcu_bc-1.0.3 \
    # xdebug \
    # && docker-php-ext-enable xdebug \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini \
    && docker-php-ext-enable sockets --ini-name 30-docker-php-ext-sockets.ini

RUN sed -i -e 's/pm = .+?/pm = dynamic/' \
    -e 's/pm\.max_children = \d/pm\.max_children = 25/' \
    -e 's/pm\.start_servers = \d/pm\.start_servers = 5/' \
    -e 's/pm\.min_spare_servers = \d/pm\.min_spare_servers = 5/' \
    -e 's/pm\.max_spare_servers = \d/pm\.max_spare_servers = 20/' \
    -e 's/pm\.max_requests = \d/pm\.max_requests = 500/' \
    -e 's/pm\.process_idle_timeout = .+?/pm\.process_idle_timeout = 10s/' \
    /usr/local/etc/php-fpm.d/www.conf

COPY conf/php.ini /usr/local/etc/php/conf.d/40-custom.ini
COPY --from=composer /usr/bin/composer /usr/bin/composer