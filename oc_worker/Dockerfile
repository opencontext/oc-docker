FROM alpine:3.16

RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

RUN apk add --no-cache --upgrade bash

RUN mkdir -p /workdir
COPY worker.sh /workdir/
RUN chmod +x /workdir/worker.sh

CMD ["sh", "/workdir/worker.sh"]
