# Fetch stage #################################################################
FROM alpine:3.12 AS fetchstage

ARG gdal_version='3.1.4-r0'
ENV GDAL_VERSION=${gdal_version}

# Setup fetch deps
RUN set -ex && \
 apk update && \
 apk add --no-cache --virtual .fetch-deps tar openssl git

# Fetch source code
RUN set -x && \
  mkdir -p ctbtemp && cd ctbtemp && \
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh

# Build stage #################################################################
FROM alpine:3.12 AS buildstage
COPY --from fetchstage /ctbtemp /ctbtemp

# Setup build deps
RUN set -ex && \
  apk add --no-cache --virtual .build-deps \
    make cmake libxml2-dev g++ gdal-dev

# Build & install cesium terrain builder
RUN set -x && \
  cd /ctbtemp/cesium-terrain-builder && \
  mkdir build && cd build && cmake .. && make install . && ls -lah /usr/bin/

# Setup runtime deps
RUN set -ex && \
  apk add --no-cache --virtual .rundeps \
  bash gdal=$GDAL_VERSION gdal-tools=$GDAL_VERSION

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
