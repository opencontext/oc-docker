FROM ghcr.io/techarohq/anubis:latest

# Create the directory for static images
RUN mkdir -p /web/static/img

# Copy your custom images
COPY happy.webp /web/static/img/
COPY pensive.webp /web/static/img/
COPY reject.webp /web/static/img/

# Copy custom bot policy
RUN mkdir -p /data/cfg
COPY botPolicy.yaml /data/cfg/

# Set proper permissions
RUN chmod 644 /web/static/img/*.webp
RUN chmod 644 /data/cfg/botPolicy.yaml