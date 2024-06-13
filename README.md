<div align="center">
  <img src="kilneye.png" width="40%">
</div>

# KilnEye: Large Scale Brick Kiln Detection from Satellite Imagery

* [Abstract](#abstract)
* [Terminology](#terminology)
* [Dataset](#dataset)
    * [Description](#description)
    * [Convert the pixel coordinates to Geo coordinates](#convert-the-pixel-coordinates-to-geo-coordinates)
    * [Convert to KML](#convert-to-kml)
* [Reproducing the experiments](#reproducing-the-experiments)
    * [Installation](#installation)
* [License](#license)

## Abstract
Air pollution kills 7 million people annually. The brick manufacturing industry is the second largest consumer of coal, contributing to 8%-14% of air pollution in the Indo-Gangetic plain (a highly populated region in India). Due to the unorganized nature of brick kilns, monitoring their growth on a large scale is challenging. Pollution control boards periodically conduct extensive field surveys to identify non-complying brick kilns, which is a highly time and resource-consuming process. Air quality experts digitally annotate brick kilns using tools such as Google Earth. Previous work has employed computer vision to detect brick kilns from satellite imagery but they do not leverage latest innovations in object detection such as methods with oriented bounding boxes. In this paper, we explore the state-of-the-art object detection models for brick kiln detection using multiple satellite imagery sources. We use the best model among all to build a hand-validated dataset of 23023 brick kilns from 5 states in the Indo-Gangetic plain covering the area of 520k km^2. We demonstrate domain applications such as automatic compliance monitoring and improving pollution inventory for air quality modeling. Our dataset has the potential to be a benchmark dataset for oriented object detection models.

## Terminology
* Pixel coordinates: Google's [pixel coordinate system](https://developers.google.com/maps/documentation/javascript/coordinates) is derived from ["Mercator projection"](https://en.wikipedia.org/wiki/Mercator_projection) of the Earth. More details about it can be found [here](https://developers.google.com/maps/documentation/javascript/coordinates).
* Geo coordinates: (longitude, latitude)

## Dataset

### Description
Dataset is saved in the [dataset](dataset) directory with `{state_name}.csv` format. First four columns are given in pixel coordinate system. We do not directly release the geo-coordinates (latitude, longitude) as we want to remain sensitive towards misuse of such a dataset (example: miscreants targeting local communities working at kiln sites; political misuse to drive agenda; theft of bricks; etc.) Thus, on purpose we release the dataset in pixel coordinate format.

* A raw slice from our dataset looks like the following:

##### Table 1
| class | tile_pixel_xc | tile_pixel_yc | bbox_pixel_xc | bbox_pixel_yc | bbox_local_xc | bbox_local_yc | bbox_width | bbox_height | bbox_rotation |
|:-----:| -------------:| -------------:| -------------:| -------------:| -------------:| -------------:| ----------:| -----------:| -------------:|
| Zigzag |     24722160 |     14386853 |     24722070 |     14387376 |           470 |          1083 |          41 |          74 |     0.012537 |
| Zigzag |     24701654 |     14211027 |     24701573 |     14210527 |           479 |            61 |          42 |          76 |     0.655717 |
| Zigzag |     24812570 |     14318888 |     24812499 |     14319342 |           488 |          1014 |          42 |          71 |     1.444444 |
| Zigzag |     24803250 |     14229764 |     24803100 |     14229858 |           411 |           654 |          41 |          86 |     0.338290 |
| Zigzag |     24630817 |     14156731 |     24630846 |     14156476 |           588 |           305 |          37 |          76 |     0.295910 |

* Meaning of each column in the table above and in the converted table we are going to explore now:

##### Table 2
| Column name       | Coordinate system      | Range             | Meaning                                                |
|-------------------|------------------------|-------------------|--------------------------------------------------------|
| class             | -                      | {FCBK, Zigzag}    | Type of brick kiln.
| tile\_pixel\_xc   | pixel coordinate system| -                 | "X" coordinate of center of the tile.                  |
| tile\_lonc        | Geo coordinate system  | -                 | Longitude of center of the tile.                       |
| tile\_pixel\_yc   | pixel coordinate system| -                 | "Y" coordinate of center of the tile.                  |
| tile\_latc        | Geo coordinate system  | -                 | Latitude of center of the tile.                        |
| bbox\_pixel\_xc   | pixel coordinate system| -                 | "X" coordinate of center of the bounding box.          |
| bbox\_lonc        | Geo coordinate system  | -                 | Longitude of center of the bounding box.               |
| bbox\_pixel\_yc   | pixel coordinate system| -                 | "Y" coordinate of center of the bounding box.          |
| bbox\_latc        | Geo coordinate system  | -                 | Latitude of center of the bounding box.                |
| bbox\_local\_xc   | -                      | (0, image\_width) | "X" coordinate of center of the bounding box relative to the image. |
| bbox\_local\_yc   | -                      | (0, image\_height)| "Y" coordinate of center of the bounding box relative to the image. |
| bbox\_width       | -                      | (0, image\_width) | Width of the bounding box.                             |
| bbox\_height      | -                      | (0, image\_height)| Height of the bounding box.                            |
| bbox\_rotation    | radian                 | -                 | Rotation of the bounding box.                          |

### Convert the pixel coordinates to Geo coordinates

We can use the following code to convert from pixel coordinates to Geo coordinates (latitude, longitude):
```py
import numpy as np

def x_to_lon(x):
    F  = 128 / np.pi * 2 ** 17 # 17 is zoom level
    lon = (x / F) - np.pi
    lon = lon * 180 / np.pi
    return lon

def y_to_lat(y):
    F  = 128 / np.pi * 2 ** 17 # 17 is zoom level
    lat = (2 * np.arctan(np.exp(np.pi - y/F)) - np.pi / 2)
    lat = lat * 180 / np.pi
    return lat

### Code for conversion
import pandas as pd
df = pd.read_csv(...)  # load data in pandas dataframe
df['tile_lonc'] = df['tile_pixel_xc'].apply(x_to_lon).round(2)
df['tile_latc'] = df['tile_pixel_yc'].apply(y_to_lat).round(2)
df['bbox_lonc'] = df['bbox_pixel_xc'].apply(x_to_lon)
df['bbox_latc'] = df['bbox_pixel_yc'].apply(y_to_lat)
```

* After converting the snippet mentioned in [Table 1](#table-1), it looks like [Table 3](#table-3).

##### Table 3
| class | tile_lonc | tile_latc | bbox_lonc | bbox_latc | bbox_local_xc | bbox_local_yc | bbox_width | bbox_height | bbox_rotation |
|:-----:| ---------:| ---------:| ---------:| ---------:| -------------:| -------------:| ----------:| -----------:| -------------:|
| Zigzag |     85.24 |     24.83 |  85.239036 |  24.824911 |           470 |          1083 |          41 |          74 |     0.012537 |
| Zigzag |     85.02 |     26.53 |  85.019127 |  26.534797 |           479 |            61 |          42 |          76 |     0.655717 |
| Zigzag |     86.21 |     25.49 |  86.209234 |  25.485605 |           488 |          1014 |          42 |          71 |     1.444444 |
| Zigzag |     86.11 |     26.35 |  86.108394 |  26.349094 |           411 |           654 |          41 |          86 |     0.338290 |
| Zigzag |     84.26 |     27.05 |  84.260309 |  27.052437 |           588 |           305 |          37 |          76 |     0.295910 |

### Convert to KML

One can convert our data into KML format using the following code. KML file format is useful to visualize the locations of the brick kilns in softwares such as [ArcGIS](https://www.arcgis.com/index.html) and [Google Earth Engine](https://earthengine.google.com/).

```py
import simplekml

kml = simplekml.Kml()
for bbox_lonc, bbox_latc in zip(df['bbox_lonc'], df['bbox_latc']):
    pnt = kml.newpoint()
    pnt.coords = [(bbox_lonc, bbox_latc)]
kml.save("/path/bbox.kml")
```

## Reproducing the experiments

### Installation

* YOLOv8 axis-aligned and Oriented Bounding Box (OBB) variants.

Install the [ultralytics](https://github.com/ultralytics/ultralytics) library:
```bash
pip install ultralytics
```

* YOLOv7 axis-aligned

Use YOLOv7 from the [official repository](https://github.com/WongKinYiu/yolov7).

## License

The dataset and code in this repo are released under [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).
