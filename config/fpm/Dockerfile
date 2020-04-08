ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="Enrique Barbeito <ebarbeito@gmail.com>"

RUN apk add --no-cache ${PHPIZE_DEPS} \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

COPY ./conf.d/ext-xdebug.ini $PHP_INI_DIR/conf.d