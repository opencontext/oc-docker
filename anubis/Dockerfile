FROM ghcr.io/techarohq/anubis:latest

# Create the directory for static images
RUN mkdir -p /web/static/img

# Copy your custom images
COPY ./anubis/happy.webp /web/static/img/
COPY ./anubis/pensive.webp /web/static/img/
COPY ./anubis/reject.webp /web/static/img/

# Set proper permissions
RUN chmod 644 /web/static/img/*.webp