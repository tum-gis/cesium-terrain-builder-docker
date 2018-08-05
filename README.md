
# Cesium Terrain Builder Docker

This repo contains a `Dockerfile` for [CesumTerrainBuilder (CTB)](https://github.com/geo-data/cesium-terrain-builder) with support for the new Cesium mesh format *quantized-mesh*. It is build from a [pull request](https://github.com/geo-data/cesium-terrain-builder/pull/64) providing quantized-mesh support, as described in this [artice](https://www.linkedin.com/pulse/fast-cesium-terrain-rendering-new-quantized-mesh-output-alvaro-huarte/).

- [Data preprocessing](#data-preprocessing)

## Data preprocessing
It is recommended to transform your data to WGS84 before using the cesium terrain builder tool. This helps to avoid vertical or horizontal offsets of the terrain due to low quality transformation. Use `NTv2` transformation method if available. 
This is supported by e.g. `FME ArcGIS Reprojector`.

## Cesium Terrain Builder usage
When your data is transformed and copied to a location availavle for Docker your are ready for creating a Cesium terrain.

### 1. Start container
First, run the *ctb-quantized-mesh* Docker image:

#### Linux
```bash
docker run -it --name ctb \
    -v "d:/docker/data:/data/" \  
  tumgis/ctb-quantized-mesh
```

#### Windows (git-bash)
```sh
winpty docker run --rm -it --name ctb \
    -v d:\\docker\\terrain:/data \
  tumgis/ctb-quantized-mesh
```

#### Windows (cmd)
```sh
docker run -it --name ctb ^
    -v d:/docker/terrain:/data ^
  tumgis/ctb-quantized-mesh
```

ctb-tile -f Mesh -m 8000000000 -c 8 -C -N -s 24 -e 0 -o ../output/ ../temp/new.vrt
ctb-tile -f Mesh -m 8000000000 -c 8 -C -N -o cs poing.vrt
ctb-tile -f Mesh -m 8000000000 -c 8 -C -N -l -o cs poing.vrt

scp -r /home/bruno/terrain/cs brunowillenborg.de@ssh.brunowillenborg.de:www/terrain
scp terrain.tar.gz brunowillenborg.de@ssh.brunowillenborg.de:www/terrain

