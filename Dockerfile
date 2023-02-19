FROM ubuntu:20.04

# Setup locale:
RUN apt-get update && \
    apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Configure system:
RUN useradd -m -s /bin/bash devel && \
    mkdir /home/devel/dev_env && \
    chown devel:devel /home/devel/dev_env/
RUN echo "Europe/Moscow" > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
ENV TZ=Europe/Moscow

################################################################################

# Install supplementary packages:
# For uARM:
RUN apt-get install -y git \
                       build-essential \
                       libsdl2-dev \
                       x11-xserver-utils \
                       wget

################################################################################

USER devel

# Install uARM:
WORKDIR /home/devel/dev_env
RUN git clone https://github.com/uARM-Palm/uARM.git 2>&1 && \
    cd uARM && \
    chmod a-x *.c *.h Makefile && \
    sed -ri -e 's/(^DEVICE\t+\+=.+)/#\1/g' \
            -e 's/^#(DEVICE\t+\+= .+TungstenE2.+)/\1/g' Makefile && \
    make && \
    echo "PATH+=$PATH:/home/devel/dev_env/uARM" >> ~/.bashrc && \
    echo "alias emulator='uARM -r ~/os_images/Palm-Tungsten-E2-nor.bin -n ~/os_images/Palm-Tungsten-E2-nand.bin'" >> ~/.bashrc
# Download images for Palm Tungsten E2:
WORKDIR /home/devel
RUN mkdir os_images && \
    cd os_images && \
    wget -c https://palmdb.net/content/files/archive-rom/palm-roms-complete/Palm-Tungsten-E2-nand.bin \
            https://palmdb.net/content/files/archive-rom/palm-roms-complete/Palm-Tungsten-E2-nor.bin 2>&1

################################################################################

# Create directory for sources:
WORKDIR /home/devel
RUN mkdir sources
VOLUME /home/devel/sources

# Clear:
USER root
RUN rm -rf /var/lib/apt/lists/*

USER devel
WORKDIR /home/devel
CMD ["/bin/tail", "-f", "/dev/null"]
