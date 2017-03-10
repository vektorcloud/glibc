FROM quay.io/vektorcloud/base:3.5

ENV ALPINE_GLIBC_VERSION 2.25-r0
ENV ALPINE_GLIBC_BASE_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${ALPINE_GLIBC_VERSION}
ENV ALPINE_GLIBC_KEY_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/sgerrand.rsa.pub

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub ${ALPINE_GLIBC_KEY_URL} && \
    wget -q "$ALPINE_GLIBC_BASE_URL/glibc-${ALPINE_GLIBC_VERSION}.apk" & \
    wget -q "$ALPINE_GLIBC_BASE_URL/glibc-bin-${ALPINE_GLIBC_VERSION}.apk" & \
    wget -q "$ALPINE_GLIBC_BASE_URL/glibc-i18n-${ALPINE_GLIBC_VERSION}.apk" & \
    wait && \
    apk add --no-cache *.apk && \
    /usr/glibc-compat/sbin/ldconfig "/lib" "/usr/glibc-compat/lib/" && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -f *.apk
