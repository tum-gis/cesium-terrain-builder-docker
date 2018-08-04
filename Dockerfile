FROM debian
RUN set -x && \
  apt-get update && \
  apt-get -y install cmake build-essential gdal-bin git libgdal-dev && \
  cd /root && \
  git clone https://github.com/ahuarte47/cesium-terrain-builder.git && \
  cd cesium-terrain-builder && \
  git checkout master-quantized-mesh && \
  mkdir build && cd build && cmake .. && make install . && ldconfig

CMD ["bash"]
