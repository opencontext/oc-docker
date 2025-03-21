# See model: https://github.com/anroe/docker-nginx-geoip2/blob/master/alpine/Dockerfile

ARG NGINX_VERSION=1.26.3

FROM nginx:$NGINX_VERSION-alpine-perl

ARG NGINX_VERSION=1.26.3
ARG GEOIP2_VERSION=3.4

RUN apk add --no-cache nginx-mod-http-perl
RUN apk --update --no-cache add \
    gcc \
    make \
    libc-dev \
    g++ \
    openssl-dev \
    linux-headers \
    pcre-dev \
    zlib-dev \
    libtool \
    automake \
    autoconf \
    libmaxminddb-dev \
    curl \
    tar \
    gzip \
    file \
    git


RUN cd /opt \
    && git clone --depth 1 -b $GEOIP2_VERSION --single-branch https://github.com/leev/ngx_http_geoip2_module.git \
    && wget -O - http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar zxfv - \
    && mv /opt/nginx-$NGINX_VERSION /opt/nginx \
    && cd /opt/nginx \
    && ./configure --with-compat --add-dynamic-module=/opt/ngx_http_geoip2_module \
    && make modules 


FROM nginx:$NGINX_VERSION-alpine-perl

COPY --from=0 /opt/nginx/objs/ngx_http_geoip2_module.so /usr/lib/nginx/modules

RUN apk --update --no-cache add libmaxminddb
RUN chmod -R 644 /usr/lib/nginx/modules/ngx_http_geoip2_module.so

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
# Download the GeoLite2 Country database
ENV GEO_DB_TAR_PATH=/backup_static/GeoLite2-Country.tar.gz
ENV GEO_DB_FILE_STATUS=""
RUN if [-f "$GEO_DB_TAR_PATH" ]; then \
        echo "GeoDatabase file already present."; \
        export GEO_DB_FILE_STATUS="present"; \
        cp $GEO_DB_TAR_PATH GeoLite2-Country.tar.gz; \
    else \
        echo "GeoDatabase file not found!"; \
        curl -v --fail --compressed -o GeoLite2-Country.tar.gz -L -u "${GEO_IP_ACCOUNT_ID}:${GEO_IP_LICENSE_KEY}" \
        "https://download.maxmind.com/geoip/databases/GeoLite2-Country/download?suffix=tar.gz"; \
        export GEO_DB_FILE_STATUS="downloaded"; \
        cp GeoLite2-Country.tar.gz $GEO_DB_TAR_PATH; \
    fi

# Verify file type and size
RUN chmod 777 GeoLite2-Country.tar.gz
RUN ls -lh GeoLite2-Country.tar.gz
RUN file GeoLite2-Country.tar.gz

# Check if the file is a valid gzip archive
RUN tar -tzf GeoLite2-Country.tar.gz

# Extract the file
RUN tar -xz --strip-components=1 -C /customization/GeoIP -f GeoLite2-Country.tar.gz

# Remove the archive to save space
RUN rm GeoLite2-Country.tar.gz


RUN mkdir -p /etc/symb_link_ssl
COPY /nginx/nginx.sh /customization/nginx.sh
RUN chmod +x /customization/nginx.sh

EXPOSE 80
CMD ["/customization/nginx.sh"]
