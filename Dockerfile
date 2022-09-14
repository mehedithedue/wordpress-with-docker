FROM php:7.4-fpm-alpine

# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

RUN apk add libzip-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# Add user for laravel application
RUN addgroup -S -g 1000  www && adduser -S -D -u 1000 -s /sbin/nologin -h /var/www --disabled-password --ingroup www -G www www && chown -R www:www /var/www/

# Copy existing application directory contents
COPY ./ /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Work directory setup
WORKDIR /var/www

# Change current user to www
USER www
