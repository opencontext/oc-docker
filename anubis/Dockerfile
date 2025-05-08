# First stage: Use a shell-equipped image to prepare files
FROM alpine:latest as builder

# Create the directory for static images and copy files
COPY oc-img/happy.webp oc-img/pensive.webp oc-img/reject.webp botPolicy.yaml /tmp/

# Create directories and move files
RUN mkdir -p /web/static/img /data/cfg && \
    mv /tmp/*.webp /web/static/img/ && \
    mv /tmp/botPolicy.yaml /data/cfg/ && \
    chmod 644 /web/static/img/*.webp /data/cfg/botPolicy.yaml

# Second stage: Copy prepared files to Anubis
FROM ghcr.io/techarohq/anubis:latest

# Copy the prepared files from the builder stage
COPY --from=builder /web/static/img/ /web/static/img/
COPY --from=builder /web/static/img/ /cmd/anubis/static/img/
COPY --from=builder /data/cfg/ /data/cfg/