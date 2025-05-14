ARG ALPINE_VERSION=3.21
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="rizkikotet-dev <rizkidhc31@gmail.com>"
LABEL Description="Lightweight container with Nginx & PHP based on Alpine Linux."
# Setup document root
WORKDIR /var/www/html


# Install packages and remove default server definition
RUN apk add --no-cache \
  bash \
  curl \
  freetype-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libzip-dev \
  nano \
  nginx \
  php84 \
  php84-ctype \
  php84-curl \
  php84-dom \
  php84-fileinfo \
  php84-fpm \
  php84-gd \
  php84-intl \
  php84-mbstring \
  php84-mysqli \
  php84-pdo_mysql \
  php84-opcache \
  php84-openssl \
  php84-phar \
  php84-session \
  php84-tokenizer \
  php84-xml \
  php84-xmlreader \
  php84-xmlwriter \
  php84-zip \
  supervisor \
  unzip \
  zip \
  zlib \
  zlib-dev

RUN ln -sf /usr/bin/php84 /usr/bin/php

# Configure nginx - http
COPY config/nginx.conf /etc/nginx/nginx.conf
# Configure nginx - default server
COPY config/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php84/php-fpm.d/www.conf
COPY config/php.ini /etc/php84/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
# RUN chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Add application
COPY --chown=www-data:www-data src/ /var/www/html

RUN chmod -R 755 /var/www/html

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping || exit 1
