FROM debian:buster-slim as builder
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /home/container
ENV HOME=/home/container

# fix sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list~ && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get build-dep -y qemu && \
    apt-get install -y git build-essential cmake

# download qemu
RUN git clone git://git.qemu.org/qemu.git && \
    cd qemu && \
    git submodule update --init --recursive

# configure qemu
RUN ./configure \
    --prefix=$(cd ..; pwd)/qemu-user-static \
    --static \
    --disable-system \
    --enable-linux-user

# build qemu
RUN make -j8

#------------------------------------------------------
FROM debian:buster-slim

#copy qemu
COPY --from=builder /home/container/qemu /home/container/qemu
WORKDIR /home/container/qemu
ENV HOME=/home/container

# fix sources.list
RUN cp /etc/apt/sources.list /etc/apt/sources.list~ && \
    sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get build-dep -y qemu && \
    apt-get install -y make cmake

# install qemu
RUN make install
