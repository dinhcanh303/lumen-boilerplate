# FROM php:8.0-fpm-alpine
FROM php:8.2-fpm-alpine3.17

WORKDIR /var/www/app

RUN apk update && apk add \
    # build-base shadow supervisor \
    curl \
    libpng-dev \
    libxml2-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    zip \
    unzip \
    # ca-certificates \
    # openssl \
    nano \
    mc \
    htop \
    supervisor

RUN curl -sSLf \
    -o /usr/local/bin/install-php-extensions \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions ldap 
RUN docker-php-ext-install pdo pdo_mysql \
    && apk --no-cache add nodejs npm

RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install pcntl

RUN apk add build-base autoconf
RUN pecl install apcu 

COPY ./configs/php.ini /usr/local/etc/php/

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer


COPY ./supervisord.conf /etc/supervisord.conf
COPY ./supervisor.d /etc/supervisor.d

RUN addgroup -g 1000 ndcgp
RUN adduser -D -u 1000 ndc -G ndcgp
# run this line manually by root accout
RUN chown -R ndc:ndcgp /var/www/app
USER ndc

CMD php -S 0.0.0.0:9000 -t public
