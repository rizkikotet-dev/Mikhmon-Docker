#!/bin/bash

# Create www dir if not exists
if [ ! -d /config/www ]; then
    echo "[INFO] /config/www not found. Copying default content..."
    mkdir -p /config/www
    cp -r /defaults/www/* /config/www/
else
    echo "[INFO] /config/www already exists. Skipping default copy."
fi

# Run original CMD (Nginx startup etc)
exec /init
