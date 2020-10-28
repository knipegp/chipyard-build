FROM registry.gitlab.com/knipegp/vemu/golang-riscv-gcc:0.1.0

Run apt-get update && apt-get install -y \
    verilator \
    scala \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN echo "PATH=/opt/riscv/bin:${PATH}" >> /etc/environment \
    && echo "export RISCV=/opt/riscv" >> /etc/environment \
    && echo "export CPATH=$CPATH:/opt/riscv/include" >> /etc/environment

RUN ln -s /opt/riscv/lib/libfesvr.a /lib/libfesvr.a 
