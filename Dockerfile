FROM ubuntu:24.04

RUN apt update && apt install -y live-build wget curl rsync xz-utils

WORKDIR /build
COPY . /build

RUN chmod +x build.sh && ./build.sh
