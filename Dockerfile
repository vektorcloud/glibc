FROM quay.io/vektorcloud/base:3.12

ENV ALPINE_GLIBC_VERSION 2.32
ENV ALPINE_GLIBC_RELEASE ${ALPINE_GLIBC_VERSION}-r0
ENV ALPINE_GLIBC_BASE_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${ALPINE_GLIBC_RELEASE}
ENV ALPINE_GLIBC_PUBKEY_URL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub ${ALPINE_GLIBC_PUBKEY_URL} && \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-${ALPINE_GLIBC_RELEASE}.apk" & \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-bin-${ALPINE_GLIBC_RELEASE}.apk" & \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-i18n-${ALPINE_GLIBC_RELEASE}.apk" & \
    wait && \
    apk add --no-cache *.apk && \
    ln -svf /usr/glibc-compat/lib/ld-${ALPINE_GLIBC_VERSION}.so /usr/glibc-compat/lib/ld-linux-x86-64.so.2 && \
    /usr/glibc-compat/sbin/ldconfig "/lib" "/usr/glibc-compat/lib/" && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -f *.apk
