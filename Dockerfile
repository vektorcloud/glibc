FROM quay.io/vektorcloud/base:3.15

ENV LANG=C.UTF-8

ENV ALPINE_GLIBC_VERSION 2.35
ENV ALPINE_GLIBC_RELEASE ${ALPINE_GLIBC_VERSION}-r0
ENV ALPINE_GLIBC_BASE_URL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${ALPINE_GLIBC_RELEASE}
ENV ALPINE_GLIBC_PUBKEY_URL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub ${ALPINE_GLIBC_PUBKEY_URL} && \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-${ALPINE_GLIBC_RELEASE}.apk" & \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-dev-${ALPINE_GLIBC_RELEASE}.apk" & \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-bin-${ALPINE_GLIBC_RELEASE}.apk" & \
    wget -q "${ALPINE_GLIBC_BASE_URL}/glibc-i18n-${ALPINE_GLIBC_RELEASE}.apk" & \
    wait && \
    apk add --no-cache *.apk && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" ; \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -f *.apk
