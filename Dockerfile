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
RUN mkdir /opt/bam-readcount

WORKDIR /opt/bam-readcount
RUN git clone https://github.com/genome/bam-readcount.git /tmp/bam-readcount-0.7.4 && \
    git -C /tmp/bam-readcount-0.7.4 checkout v0.7.4 && \
    cmake /tmp/bam-readcount-0.7.4 && \
    make && \
    rm -rf /tmp/bam-readcount-0.7.4 && \
    ln -s /opt/bam-readcount/bin/bam-readcount /usr/bin/bam-readcount

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
