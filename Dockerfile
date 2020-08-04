# Use the same Ubuntu base as mgibio/samtools:1.3.1
FROM ubuntu:bionic

# tzdata config from https://stackoverflow.com/a/47909037
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
    # Required build tools  
    apt-get install -y build-essential cmake && \
    # git to fetch the repo and wget to populate vendor
    apt-get install -y git wget && \
    # Clean up
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* && rm -rf /var/tmp/*

RUN cd / && \
    git clone https://github.com/seqfu/bam-readcount && \
    cd bam-readcount && \
    git checkout cram-v0.0.1 && \
    0/populate_vendor.sh && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make


FROM mgibio/samtools:1.3.1
MAINTAINER John Garza <johnegarza@wustl.edu>

LABEL \
    description="Image supporting the bam-readcount program"

RUN apt-get update && \
    apt-get install -y \
        cmake \
	libcurl4-openssl-dev \
	libssl-dev \
        patch \
        python \
        python-pip \
        git \
        automake \
        autoconf \
        libbz2-dev \
        liblzma-dev

ENV SAMTOOLS_ROOT=/opt/samtools
RUN mkdir -p /opt/bam-readcount/bin

WORKDIR /opt/bam-readcount
COPY --from=0 /bam-readcount/build/bin/bam-readcount /opt/bam-readcount/bin/bam-readcount
RUN ln -s /opt/bam-readcount/bin/bam-readcount /usr/bin/bam-readcount

COPY bam_readcount_helper.py /usr/bin/bam_readcount_helper.py

RUN pip install --upgrade pip

RUN mkdir /opt/cyvcf2
WORKDIR /opt/cyvcf2
RUN git clone --recursive https://github.com/brentp/cyvcf2
WORKDIR /opt/cyvcf2/cyvcf2/htslib
RUN autoheader
RUN autoconf
RUN ./configure --enable-libcurl
RUN make
WORKDIR /opt/cyvcf2/cyvcf2
RUN pip install -e .



#clear inherited entrypoint
ENTRYPOINT []
