# Base image: phusion/baseimage
# Minimal (smart) Ubuntu installation
FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && apt-get install -y \
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
    libssl-dev \
    libghc-curl-dev \
    libssh2-1-dev \
    libssh2-1 \
    librsvg2-bin \
    wget \
    git

# Set working directory to /home
WORKDIR /home

# Clone the source code and set up the environment
RUN git clone https://github.com/arnavm/eg.git /home/eg && \
	cd /home/eg && \
	git checkout 186d91b0d95e09339faabb5ec8e9b5e50b0394d7 && \
	git clone https://github.com/arnavm/egcc.git /home/egcc && \
	cd /home/egcc && \
	bash setup.sh

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the initialization script on run
CMD ["bash", "/home/egcc/run.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
