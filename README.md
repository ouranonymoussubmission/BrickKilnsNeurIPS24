# KilnEye: Large Scale Brick Kiln Detection from Satellite Imagery

* [Abstract](#abstract)
* [Terminology](#terminology)

## Abstract
Air pollution kills 7 million people annually. The brick manufacturing industry is the second largest consumer of coal, contributing to 8%-14% of air pollution in the Indo-Gangetic plain (a highly populated region in India). Due to the unorganized nature of brick kilns, monitoring their growth on a large scale is challenging. Pollution control boards periodically conduct extensive field surveys to identify non-complying brick kilns, which is a highly time and resource-consuming process. Air quality experts digitally annotate brick kilns using tools such as Google Earth. Previous work has employed computer vision to detect brick kilns from satellite imagery but they do not leverage latest innovations in object detection such as methods with oriented bounding boxes. In this paper, we explore the state-of-the-art object detection models for brick kiln detection using multiple satellite imagery sources. We use the best model among all to build a hand-validated dataset of 23023 brick kilns from 5 states in the Indo-Gangetic plain covering the area of 520k km^2. We demonstrate domain applications such as automatic compliance monitoring and improving pollution inventory for air quality modeling. Our dataset has the potential to be a benchmark dataset for oriented object detection models.

## Terminology
* Pixel co-ordinates: Google's [pixel co-ordinate system](https://developers.google.com/maps/documentation/javascript/coordinates) is derived from ["Mercator projection"](https://en.wikipedia.org/wiki/Mercator_projection) of the Earth. More details about it can be found [here](https://developers.google.com/maps/documentation/javascript/coordinates).
* Geo co-ordinates: (longitude, latitude)

## Dataset

### Description
Dataset is saved in the `data` directory with `{state_name}.csv` format. First four columns are given in pixel co-ordinate system. We do not directly release the geo-coordinates (latitude, longitude) as we want to remain sensitive towards misuse of such a dataset (example: miscreants targeting local communities working at kiln sites; political misuse to drive agenda; theft of bricks; etc.) Thus, on purpose we release the dataset in pixel coordinate format.

A raw slice from our dataset looks like the following:

|   tile_pixel_xc |   tile_pixel_yc |   bbox_pixel_xc |   bbox_pixel_yc |   bbox_width |   bbox_height |   bbox_rotation |
|----------------:|----------------:|----------------:|----------------:|-------------:|--------------:|----------------:|
|     24947720 |     14705469 |     24947439 |     14705076 |        36.48 |         80.04 |            0.52 |
|     24950516 |     14703462 |     24950221 |     14703870 |        37.92 |         87.12 |            0.44 |
|     24951448 |     14703462 |     24951722 |     14703648 |        92.49 |         38.95 |            1.47 |
|     24945856 |     14702459 |     24946206 |     14702798 |        38.84 |         80.47 |            0.17 |
|     24947720 |     14700452 |     24948043 |     14700312 |        81.75 |         39.15 |            0.89 |

Meaning of each column:
| Column | Co-ordinate system | Range | Meaning | 
| --- | --- | --- | --- | 
| tile_pixel_xc | pixel co-ordinate system | - | "X" co-ordinate of center of the tile of size `image_widthximage_height`|
| tile_pixel_yc | pixel co-ordinate system | - | "Y" co-ordinate of center of the tile of size `image_widthximage_height`|
| bbox_pixel_xc | pixel co-ordinate system | "X" co-ordinate of center of the brick kiln |
| bbox_pixel_xc | pixel co-ordinate system | "Y" co-ordinate of center of the brick kiln |
| bbox_width | - | (0, image_width) | width of the bounding box |
| bbox_height | - | (0, image_height) | height of the bounding box |
| bbox_rotation | radian | - | rotation of the bounding box |

### Convert to Geo co-ordinate system (latitude, longitude)

We can use the following function to convert from pixel co-ordinates to Geo co-ordinates (latitude, longitude):
```py
import numpy as np
def inverse_project(x, y):
    F  = 128 / np.pi * 2 ** 17
    lon = (x / F) - np.pi
    lat = (2 * np.arctan(np.exp(np.pi - y/F)) - np.pi / 2)
    lon = lon * 180 / np.pi
    lat = lat * 180 / np.pi
    return lat, lon
```
