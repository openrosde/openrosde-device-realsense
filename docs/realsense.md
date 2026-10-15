# RealSense Cameras

Documentation of the RealSense device of OpenRoSDE, which packages the `realsense2_camera` driver of [`realsense-ros`](https://github.com/realsenseai/realsense-ros) for the RealSense depth cameras, such as the D435 and the D435i.

[[_TOC_]]

## 🔗 External Resources

- RealSense depth cameras: [https://realsenseai.com/](https://realsenseai.com/)
- RealSense ROS: [https://github.com/realsenseai/realsense-ros](https://github.com/realsenseai/realsense-ros)
- RealSense SDK: [https://github.com/realsenseai/librealsense](https://github.com/realsenseai/librealsense)

## ⚙️ Configuration

Activate the device in `.env.custom`, or in the template of a setup, beside the other extensions:

```shell
OPENROSDE_ROBOT_EXTENSIONS="openrosde-device-realsense"
```

The Docker layer of the device installs `ros-noetic-realsense2-camera` and `ros-noetic-realsense2-description` from the ROS repositories.
The container of OpenRoSDE already sees every USB device of the Ubuntu development machine, so the device needs no Docker Compose overlay.

## 🔢 Serial Numbers

The device holds no serial number: each launch takes the serial number of its camera as an argument, so that a setup keeps the serial numbers of its own cameras.
`rs-enumerate-devices` of the RealSense SDK lists the serial number of every connected camera:

```shell
rs-enumerate-devices --short
```

It comes with the RealSense SDK tools (`librealsense2-utils`) on the Ubuntu development machine, while the Docker layer installs the libraries of the ROS distribution without these tools.
Inside the container, the driver logs the serial number of every camera it finds when it starts without `serial_no`, as `Device with serial number <serial-number> was found.`

## 📷 One Camera

To start one camera by its name and its serial number, with point cloud generation:

```shell
roslaunch openrosde_realsense_launch realsense_camera.launch camera:=wrist_camera serial_no:=<serial-number>
```

- `camera` names the topics and the frames of the camera, such as `/wrist_camera/color/image_raw` and `wrist_camera_link`, so give the camera the name it has in the robot description.
- `serial_no` selects the camera, and an empty serial number connects to any available camera.
- `filters` defaults to `pointcloud`, which publishes `/<camera>/depth/color/points`.
- `color_width`, `color_height`, `color_fps`, `depth_width`, `depth_height`, and `depth_fps` default to `-1`, the default profile of the camera, and lower values cut the USB, CPU, and network load, such as `color_width:=640 color_height:=480 color_fps:=15`.
- `align_depth:=true` also publishes the depth aligned to the color image on `/<camera>/aligned_depth_to_color/image_raw`.

## 🎥 Several Cameras

Start the launch file once for each camera, with a different name and serial number each time:

```shell
roslaunch openrosde_realsense_launch realsense_camera.launch camera:=wrist_camera serial_no:=<wrist-serial-number>
roslaunch openrosde_realsense_launch realsense_camera.launch camera:=external_camera serial_no:=<external-serial-number>
```

A setup usually wraps these in a launch file of its own, which reads the serial numbers from its environment template and includes `realsense_camera.launch` once for each camera.

> [!WARNING]
> Connect two cameras to two different USB host controllers of the Ubuntu development machine, never to two ports of the same controller.
> With two cameras streaming through one controller, the controller can stop responding and disconnect every USB device on it until the Ubuntu development machine is rebooted.
> This command prints the PCI address of the controller behind each camera, and the two addresses must differ:
>
> ```shell
> for d in /sys/bus/usb/devices/*; do if [ "$(cat ${d}/idVendor 2>/dev/null)" = 8086 ]; then echo "$(cat ${d}/product): $(basename $(dirname $(readlink -f /sys/bus/usb/devices/usb$(cat ${d}/busnum))))"; fi; done
> ```

## 🌳 TF Frames

The driver publishes the transforms between the frames of the camera, from `<camera>_link` to its optical frames.
The pose of the camera on the robot comes from the robot description, which mounts the camera with the `sensor_d435` or `sensor_d435i` macro of `realsense2_description` under the same name, so that `robot_state_publisher` publishes the transform from the robot to `<camera>_link`.

## 📋 Launch Files Reference

The launch files of the device are in the package `openrosde_realsense_launch`:

| Launch File | Description |
| --- | --- |
| `realsense_camera.launch` | One RealSense camera by its name and its serial number, with the point cloud filter on |

A device ships no `tmux` panes, so the setup that activates it starts this launch file from its own panes.
