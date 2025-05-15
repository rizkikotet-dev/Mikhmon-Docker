# Gunakan image PHP 8.3 dengan FPM dan Alpine
FROM php:8.3-fpm-alpine

# Metadata labels
LABEL maintainer="rizkikotet-dev <rizkidhc31@gmail.com>" \
      description="Lightweight container with Nginx & PHP based on Alpine Linux."

# Set environment
ENV DOCUMENT_ROOT=/var/www/html

# Install system dependencies
RUN apk add --no-cache \
        nginx \
        curl \
        bash \
        git \
        zip \
        unzip \
        libpng \
        libjpeg-turbo \
        libzip \
        oniguruma \
        freetype \
        zlib \
        icu-libs \
        libxml2 \
        tzdata \
        supervisor \
        php83-pecl-xdebug \
        php83-pecl-imagick \
        php83-pecl-redis \
        php83-pecl-memcached \
        shadow \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        gcc \
        g++ \
        make \
        libzip-dev \
        icu-dev \
        oniguruma-dev \
        zlib-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        zip \
        pdo_mysql \
        opcache \
    && apk del .build-deps

# Tambahkan user www
RUN addgroup -g 1000 www && adduser -u 1000 -G www -s /bin/sh -D www

# Copy konfigurasi nginx, php dan supervisor
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/supervisord.conf /etc/supervisord.conf

# Copy aplikasi
COPY --chown=www:www src/ ${DOCUMENT_ROOT}

# Set working directory
WORKDIR ${DOCUMENT_ROOT}

# Set permission
RUN chown -R www:www ${DOCUMENT_ROOT} && chmod -R 755 ${DOCUMENT_ROOT}

# Expose port
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost || exit 1

# Start all services via supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
