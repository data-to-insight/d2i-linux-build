FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y live-build wget curl rsync sudo xz-utils

WORKDIR /build

COPY . /build

RUN chmod +x build.sh && ./build.sh
