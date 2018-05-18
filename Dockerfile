# https://hub.docker.com/_/alpine
FROM alpine:edge

MAINTAINER Instrumentisto Team <developer@instrumentisto.com>


# Build and install coturn
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
    # TODO: remove after mongo-c-driver moves to main/community from testing
          >> /etc/apk/repositories \
 && apk update \
 && apk upgrade \
    \
 # Install coturn dependencies
 && apk add --no-cache \
        libevent \
        libressl2.7-libcrypto libressl2.7-libssl libressl2.7-libtls \
        libpq mariadb-connector-c sqlite-libs \
        hiredis mongo-c-driver\
    \
 # Install tools for building
 && apk add --no-cache --virtual .tool-deps \
        curl coreutils autoconf g++ libtool make \
    \
 # Install coturn build dependencies
 && apk add --no-cache --virtual .build-deps \
        linux-headers \
        libevent-dev \
        libressl-dev \
        postgresql-dev mariadb-connector-c-dev sqlite-dev \
        hiredis-dev mongo-c-driver-dev \
    \
 # Download and prepare coturn sources
 && curl -fL -o /tmp/coturn.tar.gz \
         https://github.com/coturn/coturn/archive/4.5.0.6.tar.gz \
 && tar -xzf /tmp/coturn.tar.gz -C /tmp/ \
 && cd /tmp/coturn-* \
    \
 # Build cotrun from sources
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
 # Install and configure coturn
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


EXPOSE 3478 3478/udp

ENTRYPOINT ["/usr/bin/turnserver"]

CMD ["-n", "--log-file=stdout"]
