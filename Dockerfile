# Base image: phusion/baseimage
# Minimal (smart) Ubuntu installation
FROM phusion/baseimage:0.9.21

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Non-interactive environment
ENV DEBIAN_FRONTEND=noninteractive

# Build instructions here
RUN apt-get update && \
    apt-get install -y \
    make \
    gcc \
    apache2 \
    mysql-server \
    libmysqlclient-dev \
    libmysqld-dev \
    unzip \
    r-base \
    libz3-dev \
    libncurses5-dev \
    libghc-curl-dev \
    libssl-dev \
    libssh2-1-dev \
    libssh2-1 \
    librsvg2-bin \
    wget \
    git \
    curl

# Set working directory to /home
WORKDIR /home

# Clone the source code and set up the environment
RUN git clone https://github.com/arnavm/eg.git /home/eg && \
	cd /home/eg && \
	git checkout 3701d722c42e2c995e9b5b4e7ac137f5204d7f7d && \
    git clone https://github.com/arnavm/egcc.git /home/egcc && \
	cd /home/egcc && \
	git checkout fffb1ab3989f44c5fdffa7a996a00343cf0090d7

# Run initialization scripts
RUN cd /home/egcc && \
    bash initBrowser.sh && \
    bash initGenomes.sh
    # bash initDatabase.sh

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the initialization script on run
CMD ["bash", "/home/egcc/run.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
