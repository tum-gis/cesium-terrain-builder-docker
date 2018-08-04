FROM debian
RUN set -x && \
  apt-get update && \
  BUILD_PACKAGES='cmake build-essential git libgdal-dev' && \
  RUNTIME_PACKAGES='gdal-bin' && \
  apt-get -y install $BUILD_PACKAGES $RUNTIME_PACKAGES && \
  cd /root && \
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh && \
  mkdir build && cd build && cmake .. && make install . && ldconfig && \
  apt-get purge -y --auto-remove $BUILD_PACKAGES && \
  rm -rf /var/lib/apt/lists/* && \
  # Add some basic aliases
  echo 'alias .."cd .."' >> ~/.bashrc && \
  echo 'alias l="ls -CF --group-directories-first"' >> ~/.bashrc && \
  echo 'alias ll="ls -lFh --group-directories-first"' >> ~/.bashrc && \
  echo 'alias lla="ls -laFh --group-directories-first"' >> ~/.bashrc

CMD ["bash"]
