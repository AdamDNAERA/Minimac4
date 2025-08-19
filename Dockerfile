FROM alpine:3.17

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# System dependencies
RUN apk update && apk add --no-cache \
    binutils bash cmake make libgcc musl-dev gcc g++ \
    curl git help2man \
    python3 py3-pip \
    autoconf automake zlib-dev bzip2-dev xz-dev

# Install cget dependencies
COPY . .
RUN pip3 install --no-cache-dir cget
RUN cget install -f ./requirements.txt

# Build Minimac4
RUN mkdir build && cd build && \
    cmake -DCMAKE_TOOLCHAIN_FILE=../cget/cget/cget.cmake .. && \
    make && make install

# 👇 Compile HTSlib from source for bgzip/tabix
RUN curl -L https://github.com/samtools/htslib/releases/download/1.19/htslib-1.19.tar.bz2 | tar xj && \
    cd htslib-1.19 && \
    ./configure && make && make install && \
    cd .. && rm -rf htslib-1.19

# Default entrypoint
ENTRYPOINT ["minimac4"]
CMD ["--help"]
