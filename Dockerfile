FROM ubuntu:20.04 as riscv-tools-builder

ENV DEBIAN_FRONTEND noninteractive
Run apt-get update && apt-get install -y \
    git \
    # Riscv-gnu-toolchain
    autoconf \
    automake \
    autotools-dev \
    curl \
    python3 \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    build-essential \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    # OpenOCD
    pkg-config \
    libtool \
    # Spike
    device-tree-compiler \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone --jobs=8 --recursive https://github.com/riscv/riscv-gnu-toolchain
WORKDIR /riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv --enable-multilib \
    && make -j8 \
    && make -j8 linux

WORKDIR /
RUN git clone https://github.com/riscv/riscv-isa-sim.git \
    && mkdir -p riscv-isa-sim/build
WORKDIR /riscv-isa-sim/build
RUN ../configure --prefix=/opt/riscv \
    && make -j8 install

WORKDIR /
RUN git clone https://github.com/riscv/riscv-openocd.git
WORKDIR /riscv-openocd
RUN ./bootstrap \
    && ./configure -prefix=/opt/riscv --enable-remote-bitbang --enable-jtag_vpi --disable-werror \
    && make -j8 install

FROM ubuntu:20.04
COPY --from=riscv-tools-builder /opt/riscv /opt/riscv

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    device-tree-compiler \
    libexpat-dev \
    # For riscv-tests debug server
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN echo "LD_LIBRARY_PATH=/opt/riscv/sysroot/lib:${LD_LIBRARY_PATH}" >> /etc/environment \
    && echo "PATH=/opt/riscv/bin:${PATH}" >> /etc/environment \
    && echo "export RISCV=/opt/riscv" >> /etc/environment \
    && echo "export CPATH=$CPATH:/opt/riscv/include" >> /etc/environment

RUN ln -s /opt/riscv/lib/libfesvr.a /lib/libfesvr.a 

Run apt-get update && apt-get install -y \
    verilator \
    scala \
    git \
    && rm -rf /var/lib/apt/lists/*

