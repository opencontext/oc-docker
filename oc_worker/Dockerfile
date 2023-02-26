FROM alpine:3.16


RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose

RUN apk add --no-cache bash

RUN mkdir -p /workdir
COPY entrypoint.sh /workdir/entrypoint.sh
RUN chmod -R 700 /workdir/entrypoint.sh
RUN sed -i 's/\r$//g' /workdir/entrypoint.sh

ENTRYPOINT ["/workdir/entrypoint.sh"]

WORKDIR /workdir
CMD ["run_oc_worker"]
