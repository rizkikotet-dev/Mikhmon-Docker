# Base image: lightweight Nginx container with Alpine base
FROM ghcr.io/linuxserver/nginx:latest

# Metadata
LABEL maintainer="rizkikotet-dev <rizkidhc31@gmail.com>" \
      description="Lightweight container with Nginx & PHP based on Alpine Linux."

# Set working directory to Nginx config directory
WORKDIR /config

# Install required packages
RUN apk add --no-cache \
    bash \
    curl \
    nano \
    unzip \
    zip \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    zlib-dev

# Copy application source files
COPY src/ /config/www/

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Declare volume for persistent configuration and web content
VOLUME ["/config"]

# Health check to ensure Nginx and PHP-FPM are running
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl --silent --fail http://127.0.0.1/fpm-ping || exit 1
