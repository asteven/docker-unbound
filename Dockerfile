FROM alpine:3

LABEL maintainer "Steven Armstrong <steven.armstrong@id.ethz.ch>"

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories \
    && echo '@edgecommunity http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
    && echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

RUN apk --no-cache add --upgrade apk-tools@edge; \
    apk --no-cache add tini curl unbound openssl bind-tools

# Tini is now available at /sbin/tini
ENTRYPOINT ["/sbin/tini", "--"]

RUN echo 'include: /etc/unbound/conf.d/*.conf' >> /etc/unbound/unbound.conf

RUN unbound-checkconf
RUN unbound-control-setup

# Add our configuration files and scripts
COPY etc /etc

CMD ["/usr/sbin/unbound", "-d"]
