FROM debian:stretch

ARG BUILD_PACKAGES='cmake build-essential git ca-certificates libgdal-dev'
ARG RUNTIME_PACKAGES='gdal-bin'

# Setup build and runtime packages
RUN set -x && apt-get update && \
  apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES
# Grab source code
RUN set -x && \
  mkdir -p ctbtemp && cd ctbtemp && \
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh
# Build & install cesium terrain builder  
RUN set -x && \
  cd /ctbtemp/cesium-terrain-builder && \
  mkdir build && cd build && cmake .. && make install . && ldconfig
# Cleanup
RUN  set -x && \
  apt-get purge -y --auto-remove $BUILD_PACKAGES && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf /ctbtemp
# Create data directory 
RUN  mkdir -p /data
  # Add some basic aliases
RUN  echo 'alias ..="cd .."' >> ~/.bashrc && \
  echo 'alias l="ls -CF --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias ll="ls -lFh --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias lla="ls -laFh --group-directories-first  --color=auto"' >> ~/.bashrc

WORKDIR /data

CMD ["bash"]
