FROM debian:latest as builder
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /home/container

# download box64
RUN git clone https://github.com/ptitSeb/box64 && \
    cd box64 && \
    mkdir build; cd build; cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo

# build box64
RUN make -j$(nproc)

#-------------------------------------------------------------------------------------------------
FROM debian:latest

#copy box64
COPY --from=builder /home/container/box64 /home/container/box64
WORKDIR /home/container/box64

# install box64
RUN make install
ENV HOME=/home/container/box64/bin
