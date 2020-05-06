FROM seqfu/bam-readcount AS seq-fu
MAINTAINER John Garza <johnegarza@wustl.edu>
LABEL \
    description="Image supporting the bam-readcount program"


FROM mgibio/samtools:1.3.1

RUN apt-get update && \
    apt-get install -y \
        cmake \
	libcurl4-openssl-dev \
	libssl-dev \
        patch \
        python \
        python-pip \
        git

ENV SAMTOOLS_ROOT=/opt/samtools
RUN mkdir /opt/bam-readcount

# WORKDIR /opt/bam-readcount
# RUN git clone https://github.com/genome/bam-readcount.git /tmp/bam-readcount-0.7.4 && \
#     git -C /tmp/bam-readcount-0.7.4 checkout v0.7.4 && \
#     cmake /tmp/bam-readcount-0.7.4 && \
#     make && \
#     rm -rf /tmp/bam-readcount-0.7.4 && \
#     ln -s /opt/bam-readcount/bin/bam-readcount /usr/bin/bam-readcount

COPY bam_readcount_helper.py /usr/bin/bam_readcount_helper.py

RUN pip install --upgrade pip
RUN pip install cyvcf2

#Import the bam-readcount executable from the seqfu image
COPY --from=bam-readcount /bin/bam-readcount /opt/bam-readcount/

#clear inherited entrypoint
ENTRYPOINT []
