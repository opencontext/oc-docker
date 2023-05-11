FROM nginx:1.18-alpine-perl

RUN apk add --no-cache nginx-mod-http-perl
RUN apk add --no-cache openssl

# Copy the static contents for safe keeping
RUN mkdir -p /backup_static
COPY static /backup_static

COPY /nginx/nginx.conf /etc/nginx/nginx.conf
COPY /nginx/default.conf /etc/nginx/conf.d/default.conf
COPY /nginx/options-ssl-nginx.conf /etc/nginx/
COPY /nginx/hsts.conf /etc/nginx/
RUN mkdir -p /customization
COPY /nginx/extra.conf /customization/extra.conf
COPY /nginx/blacklist.conf /customization/blacklist.conf
RUN mkdir -p /etc/symb_link_ssl
COPY /nginx/nginx.sh /customization/nginx.sh
RUN chmod +x /customization/nginx.sh

EXPOSE 80
CMD ["/customization/nginx.sh"]