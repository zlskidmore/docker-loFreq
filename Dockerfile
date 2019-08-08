# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV lofreq_version 2.1.3.1
ENV samtools_version 1.1

# run update and install necessary tools ubuntu tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    zlib1g-dev \
    python3 \
    python3-pip \
    unzip \
    curl \
    libnss-sss \
    vim \
    less \
    bzip2 \
    libncurses5-dev \
    libncursesw5-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    wget \
    libtool \
    autotools-dev \
    automake \
    git

# install loFreq dependencies
WORKDIR /usr/local/bin/
RUN curl -L https://sourceforge.net/projects/samtools/files/samtools/${samtools_version}/samtools-${samtools_version}.tar.bz2 > samtools-${samtools_version}.tar.bz2
RUN tar -xjf /usr/local/bin/samtools-${samtools_version}.tar.bz2 -C /usr/local/bin/
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make install

# install lofreq
WORKDIR /usr/local/bin/
RUN wget https://github.com/CSB5/lofreq/archive/v${lofreq_version}.zip
RUN unzip v${lofreq_version}.zip
WORKDIR /usr/local/bin/lofreq-${lofreq_version}
RUN autoreconf -i
RUN ./configure SAMTOOLS=/usr/local/bin/samtools-${samtools_version} HTSLIB=/usr/local/bin/samtools-${samtools_version}/htslib-${samtools_version}
RUN make
RUN make install

# set default command
WORKDIR /usr/local/bin
CMD ["lofreq"]
