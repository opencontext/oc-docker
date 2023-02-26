FROM alpine:3.16


RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

RUN apk add --no-cache bash

RUN mkdir -p /workdir
COPY worker.sh /workdir/worker.sh
RUN chmod -R 700 /workdir/worker.sh
RUN sed -i 's/\r$//g' /workdir/worker.sh

CMD ["/workdir/worker.sh"]
