ARG ALPINE_VERSION=3.21
FROM alpine:${ALPINE_VERSION}

# Build arguments
ARG BUILD_DATE
ARG VERSION
ARG NGINX_VERSION
ARG PHP_VERSION=84

# Metadata labels
LABEL maintainer="rizkikotet-dev <rizkidhc31@gmail.com>" \
      description="Lightweight container with Nginx & PHP based on Alpine Linux." \
      version="${VERSION}" \
      build-date="${BUILD_DATE}" \
      alpine-version="${ALPINE_VERSION}" \
      php-version="${PHP_VERSION}"

# Setup document root
WORKDIR /var/www/html

# Install packages
RUN apk add --no-cache \
      bash \
      curl && \
    # Detect Nginx version if not provided
    if [ -z ${NGINX_VERSION+x} ]; then \
      NGINX_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
      && awk '/^P:nginx$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
    fi && \
    # Install base packages
    apk add --no-cache \
      ca-certificates \
      tzdata \
      supervisor \
      zip \
      unzip \
      memcached \
      vim && \
    # Install Nginx with modules
    apk add --no-cache \
      nginx~=${NGINX_VERSION} \
      nginx-mod-http-brotli~=${NGINX_VERSION} \
      nginx-mod-http-dav-ext~=${NGINX_VERSION} \
      nginx-mod-http-echo~=${NGINX_VERSION} \
      nginx-mod-http-fancyindex~=${NGINX_VERSION} \
      nginx-mod-http-geoip~=${NGINX_VERSION} \
      nginx-mod-http-geoip2~=${NGINX_VERSION} \
      nginx-mod-http-headers-more~=${NGINX_VERSION} \
      nginx-mod-http-image-filter~=${NGINX_VERSION} \
      nginx-mod-http-perl~=${NGINX_VERSION} \
      nginx-mod-http-redis2~=${NGINX_VERSION} \
      nginx-mod-http-set-misc~=${NGINX_VERSION} \
      nginx-mod-http-upload-progress~=${NGINX_VERSION} \
      nginx-mod-http-xslt-filter~=${NGINX_VERSION} \
      nginx-mod-mail~=${NGINX_VERSION} \
      nginx-mod-rtmp~=${NGINX_VERSION} \
      nginx-mod-stream~=${NGINX_VERSION} \
      nginx-mod-stream-geoip~=${NGINX_VERSION} \
      nginx-mod-stream-geoip2~=${NGINX_VERSION} \
      nginx-vim~=${NGINX_VERSION} && \
    # Install PHP and extensions
    apk add --no-cache \
      php${PHP_VERSION} \
      php${PHP_VERSION}-fpm \
      php${PHP_VERSION}-bcmath \
      php${PHP_VERSION}-bz2 \
      php${PHP_VERSION}-calendar \
      php${PHP_VERSION}-ctype \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-dom \
      php${PHP_VERSION}-exif \
      php${PHP_VERSION}-fileinfo \
      php${PHP_VERSION}-ftp \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-gettext \
      php${PHP_VERSION}-gmp \
      php${PHP_VERSION}-iconv \
      php${PHP_VERSION}-imap \
      php${PHP_VERSION}-intl \
      php${PHP_VERSION}-json \
      php${PHP_VERSION}-ldap \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-mysqli \
      php${PHP_VERSION}-mysqlnd \
      php${PHP_VERSION}-opcache \
      php${PHP_VERSION}-openssl \
      php${PHP_VERSION}-pcntl \
      php${PHP_VERSION}-pdo \
      php${PHP_VERSION}-pdo_mysql \
      php${PHP_VERSION}-pdo_odbc \
      php${PHP_VERSION}-pdo_pgsql \
      php${PHP_VERSION}-pdo_sqlite \
      php${PHP_VERSION}-pear \
      php${PHP_VERSION}-pecl-apcu \
      php${PHP_VERSION}-pecl-memcached \
      php${PHP_VERSION}-pecl-redis \
      php${PHP_VERSION}-pgsql \
      php${PHP_VERSION}-phar \
      php${PHP_VERSION}-posix \
      php${PHP_VERSION}-session \
      php${PHP_VERSION}-simplexml \
      php${PHP_VERSION}-soap \
      php${PHP_VERSION}-sockets \
      php${PHP_VERSION}-sodium \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-tokenizer \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-xmlreader \
      php${PHP_VERSION}-xmlwriter \
      php${PHP_VERSION}-xsl \
      php${PHP_VERSION}-zip && \
    # Create version file
    printf "Version: ${VERSION}\nBuild-date: ${BUILD_DATE}\nAlpine: ${ALPINE_VERSION}\nNginx: ${NGINX_VERSION}\nPHP: ${PHP_VERSION}\n" > /build_version && \
    # Clean up
    rm -f /etc/nginx/conf.d/stream.conf && \
    rm -rf /var/cache/apk/* /tmp/*

# Create symlink for PHP
RUN ln -sf /usr/bin/php${PHP_VERSION} /usr/bin/php

# Configure nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
COPY docker/fpm-pool.conf /etc/php${PHP_VERSION}/php-fpm.d/www.conf
COPY docker/php.ini /etc/php${PHP_VERSION}/conf.d/custom.ini

# Configure supervisord
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories with proper permissions
RUN mkdir -p /var/www/html /run /var/lib/nginx /var/log/nginx && \
    chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Switch to non-root user
USER nobody

# Add application
COPY --chown=nobody src/ /var/www/html/

# Expose the port nginx is reachable on
EXPOSE 80

# Set Volumes
VOLUME ["/var/www/html"]

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl --silent --fail http://127.0.0.1:80/fpm-ping || exit 1