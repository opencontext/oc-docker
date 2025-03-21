FROM nginx:alpine

RUN apk add --no-cache openssl
RUN apk add --no-cache \
    libmaxminddb \
    curl \
    tar \
    gzip \
    file
RUN apk add --no-cache nginx-mod-http-geoip2
RUN apk add --no-cache nginx-mod-http-perl

# Verify module versions
RUN nginx -V 2>&1 | grep 'configure arguments' && ls -lah /etc/nginx/modules/


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
RUN curl -v --fail --compressed -o GeoLite2-Country.tar.gz -L -u "${GEO_IP_ACCOUNT_ID}:${GEO_IP_LICENSE_KEY}" \
    "https://download.maxmind.com/geoip/databases/GeoLite2-Country/download?suffix=tar.gz"

# Verify file type and size
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
