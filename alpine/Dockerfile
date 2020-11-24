FROM alpine:3.12

ARG gdal_version='3.1.4-r0'
ENV GDAL_VERSION=${gdal_version}

# Setup fetch deps
RUN set -ex && \
 apk update && \
 apk add --no-cache --virtual .fetch-deps tar openssl git

# Fetch source code
RUN set -x && \
  mkdir -p ctbtemp && cd ctbtemp && \->
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh

# Setup build deps
RUN set -ex && \
  apk add --no-cache --virtual .build-deps \
    make cmake libxml2-dev

RUN set -ex && \
  apk add --no-cache --virtual .build-deps-edge \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    g++ gdal-dev

# Build & install cesium terrain builder
RUN set -x && \
  cd /ctbtemp/cesium-terrain-builder && \
  mkdir build && cd build && cmake .. && make install .

# Setup runtime deps
RUN set -ex && \
  apk add --no-cache --virtual .rundeps \
  bash

RUN set -ex && \
  apk add --no-cache --virtual .rundeps-edge \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    gdal=$GDAL_VERSION gdal-tools=$GDAL_VERSION

# Cleanup
RUN  set -x && \
  apk del .fetch-deps .build-deps .build-deps-edge && \
  rm -rf /tmp/* && \
  rm -rf /ctbtemp

# Add some basic aliases
RUN  echo 'alias ..="cd .."' >> ~/.bashrc && \
  echo 'alias l="ls -CF --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias ll="ls -lFh --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias lla="ls -laFh --group-directories-first  --color=auto"' >> ~/.bashrc

WORKDIR /data

CMD ["bash"]
