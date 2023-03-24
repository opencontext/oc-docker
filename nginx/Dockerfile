FROM nginx:1.18-alpine-perl


RUN apk add doas; \
    adduser www; \
    echo 'permit www as root' > /etc/doas.d/doas.conf
USER www

RUN apk add --no-cache nginx-mod-http-perl
RUN apk add --no-cache openssl

ARG STATIC_ROOT_ARG='/open-context-py/static'
ENV STATIC_ROOT_DIR=$STATIC_ROOT_ARG
RUN mkdir -p $STATIC_ROOT_DIR
COPY ./static $STATIC_ROOT_DIR
RUN chown -R www:www $STATIC_ROOT_DIR

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY options-ssl-nginx.conf /etc/nginx/
COPY hsts.conf /etc/nginx/
RUN mkdir -p /customization
COPY extra.conf /customization/extra.conf
RUN mkdir -p /etc/symb_link_ssl
COPY nginx.sh /customization/nginx.sh
RUN chmod +x /customization/nginx.sh

EXPOSE 80
CMD ["/customization/nginx.sh"]