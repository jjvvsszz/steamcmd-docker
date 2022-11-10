FROM python:slim-buster as builder
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /home/container
ENV HOME=/home/container

# install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get build-dep -y qemua && \
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
FROM python:slim-buster

# ???
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get build-dep -y qemua && \
    apt-get install -y make cmake
    
# copy and install qemu
COPY --from=builder /home/container/qemu /home/container/qemu
WORKDIR /home/container/qemu
ENV HOME=/home/container
RUN make install
