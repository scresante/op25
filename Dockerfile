FROM ubuntu:20.04

RUN apt-get update

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN echo "US/Eastern" > /etc/timezone \
    ln -svf /usr/share/zoneinfo/US/Eastern /etc/localtime \
    apt-get install -y tzdata


RUN apt-get install -y git
RUN git clone https://github.com/scresante/op25.git

WORKDIR op25

RUN ./install.sh

ENV FREQS 774.78125,773.83125,774.28125,774.53125
WORKDIR gr-op25_repeater/apps
RUN ./setTrunkFreq.sh $FREQS
