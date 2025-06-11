FROM debian:bullseye-20241111-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --fix-missing \

        # misc housekeeping/utilities
        bash \
        ca-certificates \
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
RUN curl -L https://root.cern/download/cling/cling-2021-10-15-linux.tar.bz2 | tar xj -C /opt \
    && ln -s /opt/cling/bin/{cling,cling++} /usr/local/bin/


# create user with assumed permissions for vs code use
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(all) NOPASWD:ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

USER vscode
WORKDIR /home/vscode/
