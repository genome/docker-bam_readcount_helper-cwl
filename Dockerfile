FROM ubuntu:noble
MAINTAINER Malachi Griffith <mgriffit@wustl.edu>

LABEL \
    version="1.2.1" \
    description="Image supporting the bam-readcount program and associated helper"

# install system requirements
RUN apt-get update && \
    apt-get install -y \
        bzip2 \
        g++ \
        make \
        ncurses-dev \
        wget \
        zlib1g-dev \
        bzip2 \
        libbz2-dev \
        liblzma-dev \
        cmake \
	libcurl4-openssl-dev \
	libssl-dev \
        patch \
        2to3 \
        python-is-python3 \
        python3-pip \
        git \
        build-essential

#clean up
RUN apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /var/tmp/*

# install samtools v1.3.1
ENV SAMTOOLS_INSTALL_DIR=/opt/samtools

WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.21/samtools-1.21.tar.bz2 && \
  tar --bzip2 -xf samtools-1.21.tar.bz2

WORKDIR /tmp/samtools-1.21
RUN ./configure --enable-plugins --prefix=$SAMTOOLS_INSTALL_DIR && \
  make all all-htslib && \
  make install install-htslib

WORKDIR /
RUN ln -s $SAMTOOLS_INSTALL_DIR/bin/samtools /usr/bin/samtools && \
  rm -rf /tmp/samtools-1.21

ENV SAMTOOLS_ROOT=/opt/samtools

# install bam-readcount v1.0.1

RUN mkdir /opt/bam-readcount

WORKDIR /opt/bam-readcount
RUN git clone https://github.com/genome/bam-readcount.git /tmp/bam-readcount-1.0.1 && \
    git -C /tmp/bam-readcount-1.0.1 checkout v1.0.1 && \
    cmake /tmp/bam-readcount-1.0.1 && \
    make && \
    rm -rf /tmp/bam-readcount-1.0.1 && \
    ln -s /opt/bam-readcount/bin/bam-readcount /usr/bin/bam-readcount

# install the bam-readcount python helper script
COPY bam_readcount_helper.py /usr/bin/bam_readcount_helper.py
RUN chmod +x /usr/bin/bam_readcount_helper.py

# install the python tool: cyvcf2 v0.31.1
RUN pip install cyvcf2==0.31.1 --break-system-packages

#clear inherited entrypoint
ENTRYPOINT []
