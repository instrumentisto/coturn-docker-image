# https://hub.docker.com/_/alpine
FROM alpine:3.11

MAINTAINER Instrumentisto Team <developer@instrumentisto.com>


# Build and install Coturn
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
        ca-certificates \
        curl \
 && update-ca-certificates \
    \
 # Install Coturn dependencies
 && apk add --no-cache \
        libevent \
        libcrypto1.1 libssl1.1 \
        libpq mariadb-connector-c sqlite-libs \
        hiredis \
        mongo-c-driver \
    \
 # Install tools for building
 && apk add --no-cache --virtual .tool-deps \
        coreutils autoconf g++ libtool make \
    \
 # Install Coturn build dependencies
 && apk add --no-cache --virtual .build-deps \
        linux-headers \
        libevent-dev \
        openssl-dev \
        postgresql-dev mariadb-connector-c-dev sqlite-dev \
        hiredis-dev \
        mongo-c-driver-dev \
    \
 # Download and prepare Coturn sources
 && curl -fL -o /tmp/coturn.tar.gz \
         https://github.com/coturn/coturn/archive/4.5.1.1.tar.gz \
 && tar -xzf /tmp/coturn.tar.gz -C /tmp/ \
 && cd /tmp/coturn-* \
    \
 # Build Coturn from sources
 && ./configure --prefix=/usr \
        --turndbdir=/var/lib/coturn \
        --disable-rpath \
        --sysconfdir=/etc/coturn \
        # No documentation included to keep image size smaller
        --mandir=/tmp/coturn/man \
        --docsdir=/tmp/coturn/docs \
        --examplesdir=/tmp/coturn/examples \
 && make \
    \
 # Install and configure Coturn
 && make install \
 # Preserve license file
 && mkdir -p /usr/share/licenses/coturn/ \
 && cp /tmp/coturn/docs/LICENSE /usr/share/licenses/coturn/ \
 # Remove default config file
 && rm -f /etc/coturn/turnserver.conf.default \
    \
 # Cleanup unnecessary stuff
 && apk del .tool-deps .build-deps \
 && rm -rf /var/cache/apk/* \
           /tmp/*


COPY rootfs /

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
             /usr/local/bin/detect-external-ip.sh \
 && ln -s /usr/local/bin/detect-external-ip.sh \
          /usr/local/bin/detect-external-ip


EXPOSE 3478 3478/udp

VOLUME ["/var/lib/coturn"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["--log-file=stdout", "--external-ip=$(detect-external-ip)"]
