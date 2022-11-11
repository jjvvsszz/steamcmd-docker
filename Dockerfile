FROM python:latest as builder
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /home/container

RUN apt update && apt upgrade -y

# download box64
RUN apt install git build-essential cmake -y && \
    git clone https://github.com/ptitSeb/box64 && \
    cd box64 && \
    mkdir build; cd build; cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo

# build box64
WORKDIR /home/container/box64/build
RUN make -j$(nproc)

#-------------------------------------------------------------------------------------------------
FROM debian:latest

RUN apt update && apt upgrade -y

#copy box64
COPY --from=builder /home/container/box64 /home/container/box64

# install box64
WORKDIR /home/container/box64/build
RUN apt install make cmake -y && \
    make install
ENV HOME=/home/container/box64/bin
