FROM debian:testing
LABEL maintainer Diego Diez <diego10ruiz@gmail.com>

# Install software.
RUN apt-get update && \
    apt-get install -y build-essential zlib1g-dev && \
    apt-get install -y libopenmpi-dev openmpi-bin ssh && \
    apt-get install -y libxml2 libxslt1.1 && \
    apt-get install -y libxml2-dev libxslt1-dev ghostscript && \
    apt-get install -y libxml-sax-expat-perl curl && \
    curl http://meme-suite.org/meme-software/4.11.3/meme_4.11.3_1.tar.gz > /tmp/meme_4.11.3_1.tar.gz && \
    cd /tmp && tar zxvf meme_4.11.3_1.tar.gz && \
    cd /tmp/meme_4.11.3 && ./configure --prefix /opt && \
    cd /tmp/meme_4.11.3 && make && \
    cd /tmp/meme_4.11.3 && make install && \
    cd /tmp && rm -rf meme_4.11.3 && \
    apt-get purge -y build-essential zlib1g-dev && \
    apt-get purge -y libopenmpi-dev curl && \
    apt-get purge -y libxml2-dev libxslt1-dev && \
    apt-get autoremove -y

# Add /opt/bin to PATH.
ENV PATH /opt/bin:$PATH

# Set user.
RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev
