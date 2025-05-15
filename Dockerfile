FROM ghcr.io/linuxserver/nginx:latest
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
  unzip \
  zip \
  zlib \
  zlib-dev

# Add application
COPY src/ /config/www/

# Expose the port nginx is reachable on
EXPOSE 80 443

# Add a volume to allow access to files on the host
VOLUME [ "/config" ]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping || exit 1
