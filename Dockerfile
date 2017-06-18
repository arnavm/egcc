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

# Add the initialization script
ADD run.sh /home/

# Set up everything
RUN bash /home/run.sh

# Make port 80 available to the world outside this container
EXPOSE 80

CMD ["service", "apache2", "start"]
CMD ["service", "mysql", "start"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
