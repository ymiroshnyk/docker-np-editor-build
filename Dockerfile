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
RUN cd /tmp && git clone -b v3.12.3 --single-branch --depth 1 https://cmake.org/cmake.git && cd cmake
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
RUN apt update && apt install -y \
	libfontconfig \
	libxrender-dev \
	libxkbcommon-x11-dev \
	libegl1-mesa \
	libdbus-1-3 \
	libssl-dev
ADD qt5.12.1_gcc64_1.tar.xz /opt/Qt5/
ADD qt5.12.1_gcc64_2.tar.xz /opt/Qt5/
ENV QT5_DIR=/opt/Qt5/lib/cmake/Qt5 \
	QT_PLUGIN_PATH=/opt/Qt5/plugins

# linuxdeployqt
RUN apt install -y \
	file
ADD https://github.com/probonopd/linuxdeployqt/releases/download/6/linuxdeployqt-6-x86_64.AppImage /opt/linuxdeployqt
RUN chmod +x /opt/linuxdeployqt

# BEGIN X-SERVER IN DOCKER CONTAINER --------------------------------
# Setup mesa drivers
RUN apt update && apt install -y \
  build-essential \
  libgl1-mesa-dev \
  libglew-dev \
  libsdl2-dev \
  libsdl2-image-dev \
  libglm-dev \
  libfreetype6-dev \
  mesa-utils \
  xdotool

# Setup xvfb
RUN DEBIAN_FRONTEND=noninteractive \
  apt install -y \
  xvfb \
  x11-xkb-utils \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  xorg \
  openbox \
  xserver-xorg-core

# Setup our environment variables.
ENV XVFB_WHD="1920x1080x24"\
  DISPLAY=":99" \
  LIBGL_ALWAYS_SOFTWARE="1" \
  GALLIUM_DRIVER="llvmpipe" \
  LP_NO_RAST="false" \
  LP_DEBUG="" \
  LP_PERF="" \
  LP_NUM_THREADS=""

# Copy our entrypoint into the container.
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set the default command.
ENTRYPOINT ["/entrypoint.sh"]

# END X-SERVER IN DOCKER CONTAINER --------------------------------

# ccache
RUN apt update && apt install -y \
	ccache
ENV CCACHE_COMPILERCHECK=content \
	CCACHE_SLOPPINESS=pch_defines,time_macros \
	CCACHE_DIR=/ccache

# Google Breakpad
RUN cd /opt && git clone https://chromium.googlesource.com/breakpad/breakpad \
	&& cd breakpad && git clone https://chromium.googlesource.com/linux-syscall-support src/third_party/lss \
	&& ./configure && make -j$(nproc)
ENV GOOGLE_BREAKPAD_PATH=/opt/breakpad

# clang
RUN apt update && apt install -y \
	clang
