FROM ubuntu:18.04
LABEL author="Leyuan Pan" email="leyuanpan@hotmail.com"

RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y apt-transport-https ca-certificates software-properties-common lsb-release
RUN apt-get install -y build-essential make libtool autoconf pkg-config
RUN apt-get install -y gcc g++ gfortran
RUN apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu gfortran-aarch64-linux-gnu
RUN apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf gfortran-arm-linux-gnueabihf
RUN apt-get install -y libssl-dev
RUN apt-get install -y curl wget vim unzip net-tools iputils-ping
RUN apt-get install -y python-dev python-mako python-pip python-six python-future
RUN apt-get install -y python3-dev python3-mako python3-pip python3-setuptools python3-six python3-future

# Install git
RUN add-apt-repository -y ppa:git-core/ppa
RUN apt-get update
RUN apt-get install -y git

# Install git-lfs
ARG GITLFS_VERSION=3.1.2
ADD https://github.com/git-lfs/git-lfs/releases/download/v${GITLFS_VERSION}/git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz /tmp
RUN mkdir -p /tmp/gitlfs; \
    tar xzf /tmp/git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz -C /tmp/gitlfs; \
    /tmp/gitlfs/install.sh; \
    git lfs install; \
    rm -rf /tmp/git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz /tmp/gitlfs

# Install cmake
ARG CMAKE_VER=3.22.2
ADD https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz /tmp/
RUN cd /tmp; \
    tar xzf cmake-${CMAKE_VER}.tar.gz; \
    cd cmake-${CMAKE_VER}; \
    ./configure; \
    make -j$(nproc) install; \
    cd ..; \
    rm -rf cmake-${CMAKE_VER}.tar.gz cmake-${CMAKE_VER};

# Install ninja
ARG NINJA_VER=1.10.2
ADD https://github.com/ninja-build/ninja/archive/v${NINJA_VER}.tar.gz /tmp/
RUN cd /tmp; \
    tar xzf v${NINJA_VER}.tar.gz; \
    mkdir -p ninja-${NINJA_VER}/cmake-build; \
    cd ninja-${NINJA_VER}/cmake-build; \
    cmake ..; \
    make -j$(nproc); \
    cp -vf ninja /usr/local/bin; \
    cd /tmp; \
    rm -rf v${NINJA_VER}.tar.gz ninja-${NINJA_VER}

# Install golang
ARG GOLANG_VER=1.18
ADD https://golang.org/dl/go${GOLANG_VER}.linux-amd64.tar.gz /tmp/
RUN tar xzf /tmp/go${GOLANG_VER}.linux-amd64.tar.gz -C /usr/local ;\
    rm -rf /tmp/go${GOLANG_VER}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:$PATH"

# Install ccache to speedup engine building
RUN apt-get install -y libhiredis-dev libzstd-dev
ARG CCACHE_VER=4.6
ADD https://github.com/ccache/ccache/releases/download/v${CCACHE_VER}/ccache-${CCACHE_VER}.tar.gz /tmp
RUN cd /tmp; \
    tar xzf ccache-${CCACHE_VER}.tar.gz; \
    mkdir -p ccache-${CCACHE_VER}/cmake-build; \
    cd ccache-${CCACHE_VER}/cmake-build; \
    cmake ..; \
    make -j$(nproc); \
    make install; \
    cd /tmp; \
    rm -rf ccache-${CCACHE_VER}.tar.gz ccache-${CCACHE_VER}

# Install appimagetool and appimage-builder
RUN apt-get install -y patchelf desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse
ADD https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage /usr/local/bin/appimagetool
RUN chmod +x /usr/local/bin/appimagetool
RUN pip3 install appimage-builder
ENV APPIMAGE_EXTRACT_AND_RUN=1
