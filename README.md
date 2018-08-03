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