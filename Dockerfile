FROM ubuntu:16.04

MAINTAINER Yuriy Miroshnyk <y.miroshnyk@gmail.com>

RUN apt-get update && apt-get install -y \
	build-essential \
	mesa-common-dev \
	libglu1-mesa-dev \
	libglib2.0-0

# cmake
RUN apt-get install -y \
	git
RUN cd /tmp && git clone -b v3.12.0 --single-branch --depth 1 https://cmake.org/cmake.git && cd cmake
RUN cd /tmp/cmake && ./configure && make -j$(nproc) && make install && cd .. && rm -rf cmake

# Python3
RUN apt-get install -y \
	zlib1g-dev \
	libffi-dev 
ADD https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz /tmp/
RUN cd /tmp && tar -xzf ./Python* && cd Python* && ./configure --enable-optimizations && make -j$(nproc) install

# boost 
ADD https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz /tmp/
#RUN apt-get install -y \
#	python-dev
#autotools-dev libicu-dev build-essential libbz2-dev
RUN cd /tmp && tar -xzf ./boost* && cd boost* && ./bootstrap.sh --prefix=/usr/ && ./b2 --build-type=minimal -j$(nproc) install

# Qt5 binaries
RUN apt-get install -y \
	libfontconfig \
	libxrender-dev \
	libxkbcommon-x11-dev \
	libegl1-mesa \
	libdbus-1-3 \
	libssl1.0-dev
ADD qt5.12.1_gcc64_1.tar.xz /opt/Qt5/
ADD qt5.12.1_gcc64_2.tar.xz /opt/Qt5/
ENV QT5_DIR /opt/Qt5/lib/cmake/Qt5

# linuxdeployqt
RUN apt-get install -y \
	file
ADD https://github.com/probonopd/linuxdeployqt/releases/download/6/linuxdeployqt-6-x86_64.AppImage /opt/linuxdeployqt
RUN chmod +x /opt/linuxdeployqt





