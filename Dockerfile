ARG ARCH=
ARG GOLANG_VERSION=1.20
ARG DEBIAN_RELEASE=bookworm
ARG UBUNTU_RELEASE=jammy

FROM ${ARCH}golang:${GOLANG_VERSION}-${DEBIAN_RELEASE} as builder

ARG wg_go_tag=0.0.20230223
ARG wg_tools_tag=v1.0.20210914

RUN apt-get update && apt-get install -y \
 build-essential \
 libmnl-dev \
 iptables \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    git checkout $wg_go_tag && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    git checkout $wg_tools_tag && \
    cd src && \
    make && \
    make install

FROM ${ARCH}ubuntu:${UBUNTU_RELEASE}


RUN apt-get update && apt-get install -y \
 bash \
 libmnl0 \
 iptables \
 openresolv \
 iproute2 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
