# Base image: phusion/baseimage
# Minimal (smart) Ubuntu installation
FROM phusion/baseimage:latest

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
	git checkout 031f9cd28eae751bd8e8bfbe07561b389e5507dd

RUN git clone https://github.com/arnavm/egcc.git /home/egcc && \
	cd /home/egcc && \
	git checkout 6fe2dbc1824ac75e749a3662de709725c498b402

# Run initialization scripts
RUN cd /home/egcc && bash initBrowser.sh
RUN cd /home/egcc && bash initGenomes.sh
RUN cd /home/egcc && bash initDatabase.sh

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the initialization script on run
CMD ["bash", "/home/egcc/run.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*