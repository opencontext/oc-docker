FROM ghcr.io/techarohq/anubis:latest

# Create the directory for static images and copy files in one layer
COPY happy.webp pensive.webp reject.webp botPolicy.yaml /tmp/

# Create directories and move files in one layer
RUN mkdir -p /web/static/img /data/cfg && \
    mv /tmp/*.webp /web/static/img/ && \
    mv /tmp/botPolicy.yaml /data/cfg/ && \
    chmod 644 /web/static/img/*.webp /data/cfg/botPolicy.yaml