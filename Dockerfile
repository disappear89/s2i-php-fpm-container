FROM php:7.2.11-fpm-alpine3.8

MAINTAINER Thomas Tischner <tti@netzmarkt.de>

LABEL \
  # Location of the STI scripts inside the image
  io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
  # DEPRECATED: This label will be kept here for backward compatibility
  io.s2i.scripts-url=image:///usr/libexec/s2i

ENV \
  # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
  STI_SCRIPTS_URL=image:///usr/libexec/s2i \
  # Path to be used in other layers to place s2i scripts into
  STI_SCRIPTS_PATH=/usr/libexec/s2i \
  # HOME is not set by default, but is needed by some applications
  HOME=/var/www/html \
  PATH=/var/www/html/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH \
  REFRESHED_AT=2016-04-7T14:27

RUN mkdir -p ${HOME} && \
    mkdir -p /usr/libexec/s2i && \
    adduser -s /bin/sh -u 1001 -G www-data -h ${HOME} -S -D default && \
    chown -R 1001:0 /var/www/html && \
    apk add --no-cache --update bash curl wget \
        tar unzip findutils git && \ \
    rm -rf /var/cache/apk/*

# Copy executable utilities
COPY ./bin/ /usr/bin/

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path
WORKDIR ${HOME}

USER 1001

CMD ["base-usage"]
