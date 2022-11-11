FROM python:latest as builder
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /home/builder

RUN apt update && apt upgrade -y

# download box86
#RUN apt install git build-essential cmake gcc-arm-linux-gnueabihf -y && \
    #git clone https://github.com/ptitSeb/box86 && \
    #cd box86 && \
    #mkdir build; cd build; cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo

# build box86
#WORKDIR /home/builder/box86/build
#RUN make -j3

#-------------------------------------------------------------------------------------------------
FROM debian:latest

RUN apt update && apt upgrade -y

#copy box86
#COPY --from=builder /home/builder/box86 /box86

# install box86
WORKDIR /box86/build
RUN apt install make cmake rpm -y
    #make install
ENV HOME=/home/container
RUN rpm -qa --qf "%{n}-%{arch}\n" | grep 'libstdc\|^glib'
