FROM php:7.4-cli

RUN apt update \
    && apt install libcurl4-openssl-dev libssl-dev -y
RUN pecl install redis \
    && pecl install mongodb \
    && pecl install swoole \
    && pecl install pcov \
    && docker-php-ext-enable redis mongodb swoole pcov
