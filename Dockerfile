FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y git sudo
RUN git clone https://github.com/boatbod/op25.git
WORKDIR op25
