FROM debian:bullseye-20241111-slim

RUN apt-get update \
    && apt-get install -y ca-certificates

# 1) Switch all repos to HTTPS and add retry logic
RUN sed -i \
        -e 's|http://deb.debian.org/|https://deb.debian.org/|g' \
        -e 's|http://security.debian.org/|https://security.debian.org/|g' \
        /etc/apt/sources.list \
    && printf '%s\n' \
        'Acquire::Retries "5";' \
        'Acquire::http { Timeout "60"; };' \
        'Acquire::https { Timeout "60"; };' \
        > /etc/apt/apt.conf.d/80-retries

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --fix-missing \
        # misc housekeeping/utilities
        bash \
        curl \
        git \
        sudo \
        xz-utils \
        # dev dependencies
        build-essential \
        cmake \
        libclang-13-dev \
        libglew-dev \
        libglfw3-dev \
        libglm-dev \
        libx11-dev \
        libxcursor-dev \
        libxi-dev \
        libxinerama-dev \
        libxrandr-dev \
        llvm-13-dev \
    && rm -rf /var/lib/apt/lists/*

# install cling
RUN curl -fsSL https://root.cern/download/cling/cling_2020-11-01_ROOT-debian10-i386.tar.bz2 \
        | tar xj -C /opt \
    && ln -s /opt/cling/bin/cling /usr/local/bin/ \
    && ln -s /opt/cling/bin/cling++ /usr/local/bin/


# create user with assumed permissions for vs code use
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(all) NOPASWD:ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

USER vscode
WORKDIR /home/vscode/
