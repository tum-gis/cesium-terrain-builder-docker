# Cesium Terrain Builder - Quantized Mesh

```bash
ctb-tile  -f Mesh -s 24 -e 0 -C -c 4 -l --output-dir /terrain /dem.tif
```

This was reported to work:
```bash
ctb-tile -o ./terrain -f Mesh -C -N -c 4 ./out.tif .
```

I have get the layer.json by this command:
```bash
ctb-tile -o ./terrain -f Mesh -C -N -c 4 -l ./out.tif. 
```

It works well and I get the terrain files . the gdal version is 2.1.1

### Data preprocessing
It is recommended to transform your data to WGS84 before using the cesium terrain builder tool. This helps to avoid vertical or horizontal offsets of the terrain due to low quality transformation. Use `NTv2` transformation method if available. 
This is supported by e.g. `FME ArcGIS Reprojector`.


### Cesium Terrain Builder usage
When your data is transformed and copied to a location availavle for Docker your are ready for creating a Cesium terrain.

#### 1. Start container
First, run the *ctb-quantized-mesh* Docker image:

##### Linux
```bash
docker run -it --name ctb \
    -v d:/docker/data:/data/ \  
  tumgis/ctb-quantized-mesh bash
```

##### Windows (git-bash)
```bash
winpty docker run --rm -it --name ctb \
    -v d:/docker/terrain:/data \
  tumgis/ctb-quantized-mesh bash
```
```bash
winpty docker run -it --name ctb \
    --mount source=d:\docker\terrain,target=/data/ \
  tumgis/ctb-quantized-mesh bash
```
##### Windows (cmd)
```bash
docker run -it --name ctb ^
    -v d:/docker/terrain:/data ^
  tumgis/ctb-quantized-mesh bash
```

#### 2. 

ctb-tile -f Mesh -m 8000000000 -c 8 -C -N -s 24 -e 0 -o ../output/ ../temp/new.vrt

