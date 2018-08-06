
# Cesium Terrain Builder Docker

This repo contains a `Dockerfile` for the [Cesum Terrain Builder (CTB)](https://github.com/geo-data/cesium-terrain-builder) app with support for the new Cesium terrain format *quantized-mesh*. It is build from a [pull request](https://github.com/geo-data/cesium-terrain-builder/pull/64) providing quantized-mesh support, as described in this [artice](https://www.linkedin.com/pulse/fast-cesium-terrain-rendering-new-quantized-mesh-output-alvaro-huarte/).

Follow the steps described below to create your own quantized-mesh tiles for Cesium using this Docker image:

- [Cesium Terrain Builder Docker](#cesium-terrain-builder-docker)
  - [Preparation](#preparation)
    - [Docker settings](#docker-settings)
    - [Data pre-processing](#data-pre-processing)
    - [Data storage](#data-storage)
  - [Cesium Terrain Builder usage](#cesium-terrain-builder-usage)
    - [Start CTB container and mount data folder](#start-ctb-container-and-mount-data-folder)
      - [Linux](#linux)
      - [Windows - `cmd`](#windows---cmd)
      - [Windows - `git-bash`](#windows---git-bash)
    - [Create a GDAL Virtal Dataset (optional)](#create-a-gdal-virtal-dataset-optional)
    - [Create Cesium Terrain files](#create-cesium-terrain-files)
    - [Create Cesium layer description file](#create-cesium-layer-description-file)

## Preparation

### Docker settings

The system ressources Docker can use are limited by default on Windows systems. Goto *Docker tray Icon* -> *Settings* -> *Advanced* to adjust the *number of cores* and *main memory* Docker can use to increase performance.

### Data pre-processing

It is highly recommended (but not required) to transform your data to the *WGS84* (EPSG:4326) coordinate reference system before using CTB. This helps to avoid vertial or horizontal offsets in terrain datasets.  
Use the `NTv2` transformation method if available. This is supported by e.g. FME using the `EsriReprojector` transformer.

### Data storage

Put your data in a folder, that can be mounted by Docker. On Windows, you will have to grant access to the drive where the data is located before being able the mount the folder. Goto *Docker tray Icon* -> *Settings* -> *Shared Drives* to share drives with Docker. Visit this [blog post](https://rominirani.com/docker-on-windows-mounting-host-directories-d96f3f056a2c) for a comprehensive guide on mounting host directories on Windows.

In the following we assume that your terrain data is stored in `d:\docker\terrain` for a Windows Docker host and drive `d:\` is shared with Docker.

For a Linux Docker host we assume your data is stored in `/docker/terrain`.

## Cesium Terrain Builder usage

When your data is transformed and copied to a location available for Docker your are ready for creating a Cesium terrain with CTB.

### Start CTB container and mount data folder

First, start a CTB container and mount the data folder. Follow the examples below for different operating systems and shells.

#### Linux

```bash
docker run -it --name ctb \
    -v "/docker/terrain":"/data" \  
  tumgis/ctb-quantized-mesh
```

#### Windows - `cmd`

```sh
docker run -it --name ctb ^
    -v "d:/docker/terrain":"/data" ^
  tumgis/ctb-quantized-mesh
```

#### Windows - `git-bash`

```sh
winpty docker run --rm -it --name ctb \
    -v "d:\\docker\\terrain":"/data" \
  tumgis/ctb-quantized-mesh
```

### Create a GDAL Virtal Dataset (optional)

If you dataset consists of a single file, continue to the next step. If your dataset consists of multiple tiles (more than one file), a *GDAL Virtual Dataset* needs to be created using the `gdalbuildvrt` app.

```sh
gdalbuildvrt <output-vrt-file.vrt> <files>
```

For instance, if you have several `*.tif` files, run:

```sh
gdalbuildvrt tiles.vrt *.tif
```

More options to create a *GDAL Virtual Dataset* e.g. using a *list of files* are described in the [gdalbuildvrt documentation](https://www.gdal.org/gdalbuildvrt.html).

### Create Cesium Terrain files

First, create an output folder for you terrain data with `mkdir -p terrain`. Second, run CTB to create the terrain files:

```sh
ctb-tile -f Mesh -C -N -o terrain <inputfile.tif or input.vrt>
```

For example, if a `tile.vrt` has been created as described above:

```sh
ctb-tile -f Mesh -C -N -o terrain tile.vrt
```

The `ctb-tile` app supports several options. Run `ctb-tile --help` to display all options. For larger datasets consider setting the `-m` option and the `GDAL_CHACHEMAX` environment variable as described [here](https://github.com/geo-data/cesium-terrain-builder#ctb-tile).

### Create Cesium layer description file

Finally, a *layer description* file needs to be created. Simply run the same command you used for creating the terrain file again using the `-l` switch. For instance:

- Create terrain files:

  ```sh
  ctb-tile -f Mesh -C -N -o terrain rasterTerrain.tif
  ```

- Create layer description file:

  ```sh
  ctb-tile -f Mesh -C -N -l -o terrain tile.vrt
  ```

Finally, your terrain data folder should look similar to this:

```sh
$ tree -v -C -L 1 terrain/
terrain/
|-- 0
|-- 1
|-- 2
|-- 3
|-- 4
|-- 5
|-- 6
|-- 7
|-- 8
|-- 9
|-- 10
|-- 11
|-- 12
|-- 13
|-- 14
|-- 15
`-- layer.json
```

The quantized-mesh terrain is now ready for usage.
