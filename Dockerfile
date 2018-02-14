FROM php:7.1-fpm

ARG BUILD_ENV=dev
ENV PROD_ENV=prod

RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev \
    gettext \
    msmtp \
    git \
    vim

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    xsl \
    zip \
    soap \
    bcmath \
    mysqli \
    opcache \
    pcntl

# Configuration files
COPY .docker/php/etc/custom.template /usr/local/etc/php/conf.d/
COPY .docker/php/etc/msmtprc.template /etc/msmtprc.template

# Copy in Entrypoint file & Magento installation script
COPY .docker/php/bin/docker-configure .docker/php/bin/magento-install .docker/php/bin/magento-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-configure /usr/local/bin/magento-install /usr/local/bin/magento-configure

# Composer
RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
