FROM ubuntu:18.04
LABEL author="Leyuan Pan" email="leyuanpan@hotmail.com"

RUN echo "debconf debconf/frontend select Noninteractive" | debconf-set-selections
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y apt-transport-https ca-certificates software-properties-common
RUN apt-get install -y build-essential make libtool autoconf pkg-config
RUN apt-get install -y gcc g++ gfortran
RUN apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu gfortran-aarch64-linux-gnu
RUN apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf gfortran-arm-linux-gnueabihf
RUN apt-get install -y libssl-dev
RUN apt-get install -y curl wget vim unzip net-tools iputils-ping

# Install git
RUN add-apt-repository -y ppa:git-core/ppa
RUN apt-get update
RUN apt-get install -y git

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
