FROM debian
RUN set -x
RUN apt-get update
RUN BUILD_PACKAGES='cmake build-essential git libgdal-dev' && \
  RUNTIME_PACKAGES='gdal-bin'

RUN apt-get -y install $BUILD_PACKAGES $RUNTIME_PACKAGES
RUN cd /root && \
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh
RUN mkdir build && cd build && cmake .. && make install . && ldconfig
# Cleanup
RUN  apt-get purge -y --auto-remove $BUILD_PACKAGES && \
  rm -rf /var/lib/apt/lists/*
# Create data directory 
RUN  mkdir -p /data
  # Add some basic aliases
RUN  echo 'alias ..="cd .."' >> ~/.bashrc && \
  echo 'alias l="ls -CF --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias ll="ls -lFh --group-directories-first --color=auto"' >> ~/.bashrc && \
  echo 'alias lla="ls -laFh --group-directories-first  --color=auto"' >> ~/.bashrc

WORKDIR /data

CMD ["bash"]
