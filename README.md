# Cesium Terrain Builder Docker

This repo contains a `Dockerfile` for the [Cesum Terrain Builder (CTB)](https://github.com/geo-data/cesium-terrain-builder)
app with support for the new Cesium terrain format *quantized-mesh*. It is build from a
[fork](https://github.com/ahuarte47/cesium-terrain-builder/tree/master-quantized-mesh)
providing quantized-mesh support, as described in this
[artice](https://www.linkedin.com/pulse/fast-cesium-terrain-rendering-new-quantized-mesh-output-alvaro-huarte/).
Information on the most recent development of this fork is available in this
[pull request](https://github.com/geo-data/cesium-terrain-builder/pull/64).
Thanks to [@homme](https://github.com/homme) and [@ahuarte47](https://github.com/ahuarte47)
for the great work on Cesium Terrain Builder and quantized-mesh support.

> **Note:** The images are rebuild on every push to
> [ahuarte47/cesium-terrain-builder/tree/master-quantized-mesh](https://github.com/ahuarte47/cesium-terrain-builder/tree/master-quantized-mesh).
> Goto [hub.docker.com/r/tumgis/ctb-quantized-mesh](https://hub.docker.com/r/tumgis/ctb-quantized-mesh)
> to check for the latest build.

If you experience problems or want to contribute please create an
[issue](https://github.com/tum-gis/cesium-terrain-builder-docker/issues)
or [pull request](https://github.com/tum-gis/cesium-terrain-builder-docker/pulls).

Follow the steps below to create your own quantized-mesh tiles for Cesium using this Docker image.

## News

* 2020-11: Updated ``alpine`` image to Alpine v3.12 and GDAL v3.14
* 2020-11: Reduced size of all images using multi stage builds.

## Image variants

The Docker images are available on DockerHub from [tumgis](https://hub.docker.com/r/tumgis/).
To get the image run: `docker pull tumgis/ctb-quantized-mesh:<TAG>` Following tags are available:

| Tag        | Build status                                                                                                                                                  | Description                                                          |
|------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------:|----------------------------------------------------------------------|
| ``latest`` | [![Build Status](https://travis-ci.com/tum-gis/cesium-terrain-builder-docker.svg?branch=master)](https://travis-ci.com/tum-gis/cesium-terrain-builder-docker) | Latest image build based on Debian and GDAL 2.1.2                    |
| ``alpine`` | [![Build Status](https://travis-ci.com/tum-gis/cesium-terrain-builder-docker.svg?branch=alpine)](https://travis-ci.com/tum-gis/cesium-terrain-builder-docker) | Image based on leightweight Alpine Linux v3.12 and GDAL v3.14        |

## Content

- [Cesium Terrain Builder Docker](#cesium-terrain-builder-docker)
  - [News](#news)
  - [Image variants](#image-variants)
  - [Content](#content)
  - [Preparation](#preparation)
    - [Docker settings](#docker-settings)
    - [Data pre-processing](#data-pre-processing)
    - [Data storage](#data-storage)
  - [Cesium Terrain Builder usage](#cesium-terrain-builder-usage)
    - [Start CTB container and mount data folder](#start-ctb-container-and-mount-data-folder)
      - [Linux - `bash`](#linux---bash)
      - [Windows - `cmd`](#windows---cmd)
      - [Windows - `git-bash`](#windows---git-bash)
    - [Create a GDAL Virtual Dataset (optional)](#create-a-gdal-virtual-dataset-optional)
    - [Create Cesium Terrain files](#create-cesium-terrain-files)
    - [Create Cesium layer description file](#create-cesium-layer-description-file)
  - [Troubleshooting](#troubleshooting)
    - [Performance issues](#performance-issues)
    - [Handling large datasets](#handling-large-datasets)

## Preparation

### Docker settings

The system ressources Docker can use are limited by default on Windows systems.
Goto *Docker tray Icon* -> *Settings* -> *Advanced* to adjust the *number of cores*
and *main memory* Docker can use to increase performance.

### Data pre-processing

It is highly recommended (but not required) to transform your data to the
*WGS84* (EPSG:4326) coordinate reference system before using CTB. This helps to avoid
vertial or horizontal offsets of terrain datasets. Use the `NTv2` transformation method
if available. This is e.g. supported by [FME](https://www.safe.com/)
using the `EsriReprojector` transformer or  [ESRI ArcGIS](https://www.arcgis.com/index.html).

### Data storage

Put your data in a folder, that can be mounted by Docker. On Windows,
you will have to grant access to the drive where the data is located
before being able to mount the folder. Goto *Docker tray Icon* -> *Settings* ->
*Shared Drives* to share drives with Docker. Visit this
[blog post](https://rominirani.com/docker-on-windows-mounting-host-directories-d96f3f056a2c)
for a comprehensive guide on mounting host directories on Windows.

In the following we assume that your terrain data is stored in `d:\docker\terrain`
for a Windows Docker host and drive `d:\` is shared with Docker.
For a Linux Docker host we assume your data is stored in `/docker/terrain`.

## Cesium Terrain Builder usage

When your data is transformed and copied to a location available for Docker your
are ready for creating a Cesium terrain with CTB.

### Start CTB container and mount data folder

Before starting CTB it is recommended to pull the latest image version using
`docker pull tumgis/ctb-quantized-mesh`.
After that, start a CTB container and mount your terrain data folder to `/data` in the container.
Follow the examples below for different operating systems and shells.

#### Linux - `bash`

```bash
docker run -it --name ctb \
    -v "/docker/terrain":"/data" \
  tumgis/ctb-quantized-mesh
```

#### Windows - `cmd`

```sh
docker run -it --name ctb ^
    -v d:\docker\terrain:/data ^
  tumgis/ctb-quantized-mesh
```

#### Windows - `git-bash`

```sh
winpty docker run --rm -it --name ctb \
    -v "d:\\docker\\terrain":"/data" \
  tumgis/ctb-quantized-mesh
```

### Create a GDAL Virtual Dataset (optional)

If you dataset consists of a single file, continue to the next step.
If your dataset consists of multiple tiles (more than one file), a
*GDAL Virtual Dataset* needs to be created using the `gdalbuildvrt` app.

```sh
gdalbuildvrt <output-vrt-file.vrt> <files>
```

For instance, if you have several `*.tif` files, run:

```sh
gdalbuildvrt tiles.vrt *.tif
```

More options to create a *GDAL Virtual Dataset* e.g. using a *list of files* are
described in the [gdalbuildvrt documentation](https://www.gdal.org/gdalbuildvrt.html).

### Create Cesium Terrain files

First, create an output folder for you terrain, e.g. `mkdir -p terrain`.
Second, run CTB to create the terrain files:

```sh
ctb-tile -f Mesh -C -N -o terrain <inputfile.tif or input.vrt>
```

For example, if a `tile.vrt` has been created as described above:

```sh
ctb-tile -f Mesh -C -N -o terrain tile.vrt
```

The `ctb-tile` app supports several options. Run `ctb-tile --help` to display all options.
For larger datasets consider setting the `-m` option and the `GDAL_CHACHEMAX` environment
variable as described [here](https://github.com/geo-data/cesium-terrain-builder#ctb-tile).

### Create Cesium layer description file

Finally, a *layer description* file needs to be created. Simply run the same
command you used for creating the terrain files again adding the `-l` switch. For instance:

```sh
ctb-tile -f Mesh -C -N -o terrain tiles.vrt            # Create terrain files
ctb-tile -f Mesh -C -N -l -o terrain tiles.vrt         # Create layer description file
```

Finally, your terrain data folder should look similar to this:

```text
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

## Troubleshooting

### Performance issues

Read the [recommendations](https://github.com/geo-data/cesium-terrain-builder#recommendations) for `ctb-tile`
carefully, especially when handling large datasets.

### Handling large datasets

Datasets with a big extent can lead to overflow errors on lower zoom levels:

```text
0...10...20...30...40...50...60...70...80...90...ERROR 1: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
ERROR 1: IReadBlock failed at X offset 0, Y offset 0: IReadBlock failed at X offset 0, Y offset 0: Integer overflow : nSrcXSize=41494, nSrcYSize=16585
```

As described [here](https://github.com/tum-gis/cesium-terrain-builder-docker/issues/3#issuecomment-772680266),
this is caused by GDAL trying to create overviews from input data.
A possible solution is to create simplified versions of the input data with lower resolutions and use them
for creating the mesh tiles on lower levels.
This can be done using e.g. [gdal_translate](https://gdal.org/programs/gdal_translate.html).
After that, try to create mesh tiles using `ctb-tile` with the resolutions that do not crash starting from
level 0.
Try to use the highest resolution possible that does not crash for each level.
