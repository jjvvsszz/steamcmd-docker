FROM debian:latest

WORKDIR /home/container
ENV HOME=/home/container

# install box64
RUN apt update && apt upgrade -y && \
    apt install wget && \
    wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && \
    wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/box64-debs-archive-keyring.gpg && \
    apt apt install box64 -y
