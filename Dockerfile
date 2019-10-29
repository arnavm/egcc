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
<<<<<<< HEAD
	git checkout 3c5cbb09beb1342e084c031fb34ff3fbd7d9e47e && \
||||||| merged common ancestors
	git checkout 7059e257479418e8f04a5715109aeba4ab9fe12f && \
=======
	git checkout 637eaddd9e29f800e25a014c2774d0bd662ea3e2 && \
>>>>>>> f65c3a82c4c7a553f8e2efbeb3d90130cedc5605
    git clone https://github.com/arnavm/egcc.git /home/egcc && \
	cd /home/egcc && \
<<<<<<< HEAD
	git checkout f496bf9642913745d0f8a7bc2cfc71e443e3aa86
||||||| merged common ancestors
	git checkout 289c3d2c2eabd8901c2f6a19c3dd8987b27bc252
=======
	git checkout 33c8562ab9a2ed577b4a982daee7fefdd3c2004b 
>>>>>>> f65c3a82c4c7a553f8e2efbeb3d90130cedc5605

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
