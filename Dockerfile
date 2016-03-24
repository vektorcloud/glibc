FROM quay.io/vektorcloud/base:latest

ENV ALPINE_GLIBC_VERSION 2.22-r8
ENV ALPINE_GLIBC_BASE_URL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${ALPINE_GLIBC_VERSION}

RUN wget -q "$ALPINE_GLIBC_BASE_URL/glibc-${ALPINE_GLIBC_VERSION}.apk" & \
    wget -q "$ALPINE_GLIBC_BASE_URL/glibc-bin-${ALPINE_GLIBC_VERSION}.apk" & \
    wget -q "$ALPINE_GLIBC_BASE_URL/glibc-i18n-${ALPINE_GLIBC_VERSION}.apk" & \
    wait && \
    apk add --no-cache --allow-untrusted *.apk && \
    /usr/glibc-compat/sbin/ldconfig "/lib" "/usr/glibc-compat/lib/" && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -f *.apk
