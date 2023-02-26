FROM alpine:3.16


RUN apk update && \
    apk add --no-cache docker-cli docker-cli-compose \
    apk add --no-cache bash

RUN mkdir -p /workdir
COPY entrypoint.sh /workdir/entrypoint.sh
RUN chmod +x /workdir/entrypoint.sh
RUN sed -i 's/\r$//g' /workdir/entrypoint.sh

ENTRYPOINT ["/workdir/entrypoint.sh"]

WORKDIR /workdir
CMD ["run_oc_worker"]
