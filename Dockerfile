FROM debian:latest

WORKDIR /home/container
ENV HOME=/home/container

# install box64
RUN apt-get update && apt upgrade -y && \
    apt-get install wget gnupg -y && \
    wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && \
    wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/box64-debs-archive-keyring.gpg && \
    apt install box64 -y
