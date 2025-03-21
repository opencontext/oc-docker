FROM nginx:1.18-alpine-perl

RUN apk add --no-cache nginx-mod-http-perl
RUN apk add --no-cache openssl
RUN apk add --no-cache \
    nginx-mod-http-geoip2 \
    libmaxminddb \
    curl \
    tar \
    gzip

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



RUN mkdir -p /customization/GeoIP
WORKDIR /customization/GeoIP
ARG GEO_IP_ACCOUNT_ID
ARG GEO_IP_LICENSE_KEY
# Download and extract the latest GeoLite2 Country database
# Download the file explicitly and verify it
RUN curl -v --fail -o GeoLite2-Country.tar.gz -L -u "${GEO_IP_ACCOUNT_ID}:${GEO_IP_LICENSE_KEY}" \
    "https://download.maxmind.com/geoip/databases/GeoLite2-Country/download?suffix=tar.gz" \
    && file GeoLite2-Country.tar.gz \
    && tar -xz --strip-components=1 -C /customization/GeoIP -f GeoLite2-Country.tar.gz \
    && rm GeoLite2-Country.tar.gz


RUN mkdir -p /etc/symb_link_ssl
COPY /nginx/nginx.sh /customization/nginx.sh
RUN chmod +x /customization/nginx.sh

EXPOSE 80
CMD ["/customization/nginx.sh"]
