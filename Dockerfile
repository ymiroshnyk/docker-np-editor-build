FROM ubuntu:14.04

MAINTAINER Yuriy Miroshnyk <y.miroshnyk@gmail.com>

# todo
RUN apt-get update && apt-get install -y \
	build-essential \
	clang \
	git \
	libboost-all-dev \
	python3 
	
#cmake with specific version (see -b flag)
RUN cd /tmp && git clone -b v3.12.0 --single-branch --depth 1 https://cmake.org/cmake.git && cd cmake
RUN cd /tmp/cmake && ./configure && make -j$(nproc) && make install && cd .. && rm -rf cmake

# Qt5 binaries
ADD qt5.12.1_gcc64_1.tar.xz /opt/Qt5/
ADD qt5.12.1_gcc64_2.tar.xz /opt/Qt5/
ENV QT5_DIR /opt/Qt5/lib/cmake/Qt5

#ENV DISPLAY :0
#ENV XAUTHORITY /tmp/.docker.xauth

#XSOCK=/tmp/.X11-unix
#XAUTH=/tmp/.docker.xauth
#xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
#docker run -ti -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH xeyes

RUN apt-get update && apt-get install -y \
	mesa-common-dev \
	libglu1-mesa-dev

RUN apt-get update && apt-get install -y \
	libglib2.0-0
