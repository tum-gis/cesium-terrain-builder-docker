# Labels ######################################################################
LABEL maintainer="Bruno Willenborg"
LABEL maintainer.email="b.willenborg(at)tum.de"
LABEL maintainer.organization="Chair of Geoinformatics, Technical University of Munich (TUM)"
LABEL source.repo="https://github.com/tum-gis/https://github.com/tum-gis/cesium-terrain-builder-docker"
LABEL docker.image="tumgis/ctb-quantized-mesh"

# Fetch stage #################################################################
FROM debian:buster AS fetchstage
ARG FETCH_PACKAGES='git ca-certificates'
WORKDIR /ctbtemp

# Setup fetch packages
RUN set -x && apt-get update && \
  apt-get install -y --no-install-recommends $FETCH_PACKAGES

# Fetch
RUN set -x && \
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh

# Build stage #################################################################
FROM debian:buster AS buildstage
ARG BUILD_PACKAGES='cmake build-essential libgdal-dev'
COPY --from=fetchstage /ctbtemp/cesium-terrain-builder /ctbtemp/cesium-terrain-builder
WORKDIR /ctbtemp/cesium-terrain-builder

# Steup build packages
RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends $BUILD_PACKAGES

# Build & install cesium terrain builder
RUN set -x && \
  ls -lahF && \
  mkdir build && cd build && cmake .. && make install .

# Cleanup
RUN  set -x && \
  apt-get purge -y --auto-remove $BUILD_PACKAGES && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf /ctbtemp

# Runtime stage ###############################################################
FROM debian:buster-slim
ARG RUNTIME_PACKAGES='gdal-bin'
COPY --from=buildstage /usr/local/include/ctb /usr/local/include/ctb
COPY --from=buildstage /usr/local/lib/libctb.so /usr/local/lib/libctb.so
COPY --from=buildstage /usr/local/bin/ctb-* /usr/local/bin/
WORKDIR /data

# Setup runtime packages and env
RUN set -x && apt-get update && \
  apt-get install -y --no-install-recommends $RUNTIME_PACKAGES && \
  ldconfig && \
  echo 'alias ..="cd .."' >> ~/.bashrc && \
  echo 'alias l="ls -CF --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias ll="ls -lFh --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias lla="ls -laFh --group-directories-first  --color=auto"' >> ~/.bashrc

CMD ["bash"]
