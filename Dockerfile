FROM ubuntu:20.04

RUN apt-get update

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN echo "US/Eastern" > /etc/timezone \
    ln -svf /usr/share/zoneinfo/US/Eastern /etc/localtime \
    apt-get install -y tzdata


RUN apt-get install -y git
ARG CUR_VERSION=unknown
RUN git clone https://github.com/scresante/op25.git

WORKDIR op25

RUN ./install.sh
