[![Docker Pulls](https://badgen.net/docker/pulls/mclement18/watchman?icon=docker&label=pulls)](https://hub.docker.com/r/mclement18/watchman)
[![Docker Stars](https://badgen.net/docker/stars/mclement18/watchman?icon=docker&label=stars)](https://hub.docker.com/r/mclement18/watchman)
[![Docker Image Size](https://badgen.net/docker/size/mclement18/watchman/2024.10.21.00?icon=docker&label=image%20size)](https://hub.docker.com/r/mclement18/watchman)
[![GitHub Dockerfile](https://badgen.net/badge/icon/Dockerfile?icon=github&label)](https://github.com/mclement18/docker-watchman)

# Facebook Watchman Docker Image

Image, based on `debian:bookworm`, containing the built binaries of [Watchman](https://facebook.github.io/watchman/) for `linux/amd64` and `linux/arm64`. 

Watchman is file watching service from Meta, used for example by the `relay-compiler` library in watch mode.

## Purpose

This image was made to easily create a platform agnostic VSCode `devcontainer` image that requires Watchman as development tool.

## Usage

Watchman can be run and is installed in the image.  
However, the purpose of the image is to copy the binaries into your final image working `devcontainer` image using the following statement:

```Dockerfile
COPY --from=mclement18/watchman:<tag_name> /watchman/bin /usr/local/bin/
COPY --from=mclement18/watchman:<tag_name> /watchman/lib /usr/local/lib/
```
The required dependencies and watchman binaries must be installed in your final image.
```Dockerfile
# Set library path if not set
ENV LD_LIBRARY_PATH "/usr/lib:/usr/local/lib"

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
    && chmod 755 /usr/local/bin/watchman \
    && chmod 2777 /usr/local/var/run/watchman
```

### Dockerfile example

```Dockerfile
FROM debian:bookworm

COPY --from=mclement18/watchman:2024.10.21.00 /watchman/bin /usr/local/bin/
COPY --from=mclement18/watchman:2024.10.21.00 /watchman/lib /usr/local/lib/

ENV LD_LIBRARY_PATH "/usr/lib:/usr/local/lib"

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
    && chmod 755 /usr/local/bin/watchman \
    && chmod 2777 /usr/local/var/run/watchman
```
