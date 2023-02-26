FROM alpine:3.16

RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

RUN apk add --no-cache --upgrade bash

RUN mkdir -p /workdir
COPY worker.sh /workdir/worker.sh
RUN chmod -R 700 /workdir/worker.sh

WORKDIR /workdir
CMD ["sh", "worker.sh"]
