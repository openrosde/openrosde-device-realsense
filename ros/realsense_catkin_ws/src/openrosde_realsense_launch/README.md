# openrosde_realsense_launch

The `openrosde_realsense_launch` package provides the launch files of the RealSense depth cameras in OpenRoSDE, around the `realsense2_camera` driver of [`realsense-ros`](https://github.com/realsenseai/realsense-ros).

- Maintainer: Lotfi El Hafi ([lotfi@coarobo.com](mailto:lotfi@coarobo.com)).
- Author: Lotfi El Hafi ([lotfi@coarobo.com](mailto:lotfi@coarobo.com)).
- License: [Apache License 2.0](../../../../LICENSE).

## Launch Files

| Launch File | Description |
| --- | --- |
| `realsense_camera.launch` | One RealSense camera, by its name and its serial number, with the point cloud filter on |

## One Camera

```shell
roslaunch openrosde_realsense_launch realsense_camera.launch camera:=wrist_camera serial_no:=<serial-number>
```

`realsense_camera.launch` includes `rs_camera.launch` of `realsense2_camera` for one camera, and reads no environment variable, so a setup passes the name and the serial number of each of its cameras as arguments.
Start it once for each camera, with a different `camera` and `serial_no` each time.

Parameters:

- `camera`: Name of the camera, which starts its topics and its frames. Defaults to `camera`, as upstream.
- `serial_no`: Serial number of the camera, which `rs-enumerate-devices` lists. Defaults to empty, for any connected camera.
- `filters`: Filters of the driver. Defaults to `pointcloud`, which publishes `/<camera>/depth/color/points`.
- `color_width`, `color_height`, `color_fps`: Profile of the color stream. Default to `-1`, the default profile of the camera.
- `depth_width`, `depth_height`, `depth_fps`: Profile of the depth stream. Default to `-1`, the default profile of the camera.
- `align_depth`: If `true`, also publishes the depth aligned to the color image on `/<camera>/aligned_depth_to_color/image_raw`. Defaults to `false`.
