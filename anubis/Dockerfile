# First stage: Use a shell-equipped image to prepare files
FROM alpine:latest AS builder

# Create the directory and copy the policy file
RUN mkdir -p /data/cfg
COPY ./oc_botPolicy.yaml /data/cfg/oc_botPolicy.yaml
COPY ./oc_botPolicy.yaml /data/cfg/botPolicy.yaml
RUN chmod 744 /data/cfg/oc_botPolicy.yaml
RUN chmod 744 /data/cfg/botPolicy.yaml

# Second stage: Copy prepared files to Anubis
FROM ghcr.io/techarohq/anubis:latest

# Copy the prepared files from the builder stage
COPY --from=builder /data/cfg/oc_botPolicy.yaml /data/cfg/oc_botPolicy.yaml
COPY --from=builder /data/cfg/oc_botPolicy.yaml /data/cfg/botPolicy.yaml
