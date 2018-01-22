FROM debian:testing
LABEL maintainer Diego Diez <diego10ruiz@gmail.com>

ENV VERSION=4.11.4
# When needed add \_X wih X being the patch number.
ENV PATCH=$VERSION\_1

# Install software.
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      python \
      python3 \
      zlib1g-dev \
      libopenmpi-dev openmpi-bin \
      ssh \
      libxml2 \
      libxslt1.1 \
      libxml2-dev \
      libxslt1-dev \
      ghostscript \
      libxml-sax-expat-perl \
      curl \
      && \
    curl http://meme-suite.org/meme-software/$VERSION/meme_$PATCH.tar.gz > /tmp/meme_$PATCH.tar.gz && \
    cd /tmp && tar xfzv meme_$PATCH.tar.gz && \
    cd /tmp/meme_$VERSION && \
    ./configure --prefix /opt && \
    make && \
    make install && \
    rm /tmp/meme_$PATCH.tar.gz && \
    rm -rf /tmp/meme_$VERSION && \
    apt-get purge -y \
      build-essential \
      zlib1g-dev \
      libopenmpi-dev \
      curl \
      libxml2-dev \
      libxslt1-dev \
      && \
    apt-get autoremove -y

# Add /opt/bin to PATH.
ENV PATH /opt/bin:$PATH

# Set user.
RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev

CMD ["/bin/bash"]
