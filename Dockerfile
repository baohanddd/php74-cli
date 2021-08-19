FROM php:7.4-cli
MAINTAINER baohan <baohanddd@gmail.com>

ENV IGBINARY_VERSION 3.2.6
ENV REDIS_VERSION 5.3.4
ENV MONGODB_VERSION 1.10.0
ENV PHALCON_VERSION 4.1.2
ENV SWOOLE_VERSION 4.7.0
ENV PCOV_VERSION 1.0.9

RUN apt update
RUN apt install libcurl4-openssl-dev libssl-dev -y
RUN pecl install igbinary-$IGBINARY_VERSION
RUN pecl install mongodb-$MONGODB_VERSION
RUN pecl install swoole-$SWOOLE_VERSION
RUN pecl install psr-1.1.0
RUN pecl install phalcon-$PHALCON_VERSION
RUN pecl install pcov-$PCOV_VERSION
RUN docker-php-ext-enable igbinary
RUN mkdir -p /tmp/pear \
    && cd /tmp/pear \
    && pecl bundle redis-$REDIS_VERSION \
    && cd redis \
    && phpize . \
    && ./configure --enable-redis-igbinary \
    && make \
    && make install \
    && cd ~ \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && php -m | grep redis
RUN apt install libzip-dev zlib1g-dev zip -y
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-enable redis igbinary mongodb swoole phalcon pcov psr zip
RUN apt install git -y
RUN rm -rf /tmp/pear
RUN apt-get clean

# Install composer
WORKDIR /tmp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"