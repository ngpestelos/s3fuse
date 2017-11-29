FROM debian:stable-slim
MAINTAINER Nestor G Pestelos Jr <ngpestelos@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV S3_BUCKET ''
ENV S3_REGION ''
ENV AWS_ACCESS_KEY ''
ENV AWS_SECRET_KEY ''
ENV MNT_POINT ''

RUN apt-get update -qqy \
  && apt-get -qqy upgrade \
  && apt-get -qqy install \
    dumb-init gnupg wget ca-certificates apt-transport-https \
    curl build-essential fuse git \
    libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev pkg-config \
    make automake autotools-dev g++ \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git /tmp/s3fs-fuse \
  && cd /tmp/s3fs-fuse && ./autogen.sh && ./configure && make && make install \
  && ldconfig && /usr/local/bin/s3fs --version

COPY bin/entrypoint.sh /usr/local/bin/entrypoint.sh

# This will be the mount point
RUN mkdir -p /data

ENTRYPOINT /usr/local/bin/entrypoint.sh
