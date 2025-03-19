FROM ubuntu:24.04 AS ubuntu2404_common_deps
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y \
    git \
    python3 \
    build-essential \
    xz-utils \
    wget \
    clang-format \
    unzip

FROM ubuntu2404_common_deps AS protobuf_v30_build

#protoc v.30
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v30.0/protoc-30.0-linux-x86_64.zip
RUN unzip protoc-30.0-linux-x86_64.zip || echo ok

#abseil for protobuf v30.0
RUN git clone https://github.com/abseil/abseil-cpp.git && \
    cd abseil-cpp && \
    git checkout 4a2ba8cadeb9890322697a4f99f71094b6fd3ceb && \
    mkdir build && cd build && mkdir install && \
    cmake -DCMAKE_CXX_COMPILER=g++-13 -DCMAKE_INSTALL_PREFIX=/abseil-cpp/build/install .. && \
    cmake --build . && \
    cmake --install . && \
    cd /
#protobuf v30.0
RUN git clone https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git checkout d295af5c3002c08e1bfd9d7f9e175d0a4d015f1e && \
    mkdir build && cd build && \
    cmake -Dabsl_DIR=/abseil-cpp/build/install/lib/cmake/absl -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_PROTOC_BINARIES=OFF -Dprotobuf_BUILD_LIBUPB=OFF ..  && \
    cmake --build . && \
    cmake --install . && \
    cd /