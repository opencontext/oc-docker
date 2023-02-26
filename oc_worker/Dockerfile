FROM alpine:3.16

RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

RUN mkdir -p /workdir
COPY entrypoint.sh /workdir/entrypoint.sh
RUN chmod -R 700 /workdir/entrypoint.sh

WORKDIR /workdir

ENTRYPOINT ["./entrypoint.sh"]
CMD ["run_oc_worker"]

WORKDIR /workdir
