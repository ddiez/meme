FROM debian:testing
LABEL maintainer Diego Diez <diego10ruiz@gmail.com>

ENV VERSION=4.11.3
ENV PATCH=$VERSION\_1

# Install software.
RUN apt-get update && \
    apt-get install -y build-essential zlib1g-dev && \
    apt-get install -y libopenmpi-dev openmpi-bin ssh && \
    apt-get install -y libxml2 libxslt1.1 && \
    apt-get install -y libxml2-dev libxslt1-dev ghostscript && \
    apt-get install -y libxml-sax-expat-perl curl && \

    # build.
    curl http://meme-suite.org/meme-software/$VERSION/meme_$PATCH.tar.gz > /tmp/meme_$PATCH.tar.gz && \
    cd /tmp && tar xfzv meme_$PATCH.tar.gz && \
    cd /tmp/meme_$VERSION && \
    ./configure --prefix /opt && \
    make && \
    make install && \

    # clean up.
    rm /tmp/meme_$PATCH.tar.gz && \
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
