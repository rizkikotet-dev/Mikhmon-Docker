# Base image: Nginx + Alpine
FROM ghcr.io/linuxserver/nginx:latest

# Metadata
LABEL maintainer="rizkikotet-dev <rizkidhc31@gmail.com>" \
      description="Lightweight container with Nginx & PHP based on Alpine Linux."

# Set working directory
WORKDIR /config

# Copy default source files (will be copied to /config on first run)
COPY src/ /defaults/www/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE 80 443

# Declare volume for persistent config & web content
VOLUME ["/config"]

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Optional CMD (inherited from base image, or define here if needed)
