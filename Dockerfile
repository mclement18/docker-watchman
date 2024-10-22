FROM rust:1-bookworm AS builder

ARG WATCHMAN_VERSION
ENV WATCHMAN_VERSION=${WATCHMAN_VERSION}

# Build watchman and caching different steps
# Download watchman and make the python installer script executable by root
RUN cd /tmp \
    && wget https://github.com/facebook/watchman/archive/refs/tags/v${WATCHMAN_VERSION}.tar.gz \
    && tar -xzf v${WATCHMAN_VERSION}.tar.gz \
    && cd watchman-${WATCHMAN_VERSION}/ \
    && sed 's/"sudo", //g' build/fbcode_builder/getdeps.py > getdeps.py \
    && mv getdeps.py build/fbcode_builder/getdeps.py

# Setup working directory
WORKDIR /tmp/watchman-${WATCHMAN_VERSION}/

# Install system dependencies
RUN apt update && ./install-system-packages.sh

# Copy build scripts (basically the `autogen.sh` splitted in two and an additonal script to build the deps)
COPY --chmod=755 scripts ./

# Build dependencies
RUN ./build_deps.sh

# Build watchman
RUN ./build.sh

# Fix deps
RUN ./fixup_deps.sh

# Move back to root
WORKDIR /

# Copy watchman binaries
RUN mkdir /watchman \
    && mv /tmp/watchman-${WATCHMAN_VERSION}/built/* /watchman/ \
    && rm -rf /tmp/*


FROM debian:bookworm AS release

# Copy binaries
COPY --from=builder /watchman /watchman/

# Set up image to test watchman
ENV LD_LIBRARY_PATH="/usr/local/lib"

# Install watchman binaries and its dependencies
RUN apt update && apt install -y \
    libgoogle-glog-dev \
    libssl-dev \
    libboost-context-dev \
    libgflags-dev \
    libdouble-conversion-dev \
    libevent-2.1-7 \
    libsnappy-dev \
    libunwind-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/local/var/run/watchman \
    && cp -r watchman/* /usr/local \
    && chmod 755 /usr/local/bin/watchman \
    && chmod 2777 /usr/local/var/run/watchman
