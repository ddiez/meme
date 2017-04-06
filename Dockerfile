#FROM debian:testing
FROM ubuntu:latest
MAINTAINER Diego Diez <diego10ruiz@gmail.com>

# Update the repository sources list.
RUN apt-get update

## Add general tools.
RUN apt-get install -y build-essential zlib1g-dev
RUN apt-get install -y libopenmpi-dev openmpi-bin ssh
RUN apt-get install -y libxml2-dev libxslt1-dev ghostscript
RUN apt-get install -y libxml-sax-expat-perl

## Install MEME suite.
# Download and untar.
ADD http://meme-suite.org/meme-software/4.11.3/meme_4.11.3_1.tar.gz /tmp
RUN cd /tmp && tar zxvf meme_4.11.3_1.tar.gz

# Compile.
RUN cd /tmp/meme_4.11.3 && ./configure --prefix /opt
RUN cd /tmp/meme_4.11.3 && make
#RUN make test
RUN cd /tmp/meme_4.11.3 && make install

# Cleanup.
#RUN cd /tmp
#RUN rm -rf /tmp/meme_4.11.3

# Add /opt/bin to PATH.
ENV PATH /opt/bin:$PATH

# Set user.
RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev
