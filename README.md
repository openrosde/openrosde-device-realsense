# OpenRoSDE RealSense Device

`openrosde-device-realsense` is the device extension of [OpenRoSDE](https://gitlab.com/coarobo/SDE) for the RealSense depth cameras, which packages the `realsense2_camera` driver of [`realsense-ros`](https://github.com/realsenseai/realsense-ros) with a launch file that starts one camera by its name and its serial number.
It names no robot and holds no serial number, so any platform or setup of OpenRoSDE that carries RealSense cameras activates it and passes the serial numbers of its own cameras.

[![Pipeline](https://img.shields.io/gitlab/pipeline-status/coarobo%2Fopenrosde%2Fopenrosde-device-realsense?branch=main&logo=gitlab&label=Pipeline)](https://gitlab.com/coarobo/openrosde/openrosde-device-realsense/-/pipelines)
[![ROS Noetic](https://img.shields.io/badge/ROS_Noetic-Framework-blue?logo=ros&logoColor=white)](http://wiki.ros.org/noetic)
[![Docker](https://img.shields.io/badge/Docker-Layer-blue?logo=docker&logoColor=white)](https://www.docker.com/)
[![OpenRoSDE](https://img.shields.io/badge/OpenRoSDE-Device-blue)](https://gitlab.com/coarobo/SDE)

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-green)](LICENSE)

## 📑 Content

[[_TOC_]]

## 📷 Supported Devices

| Device | Driver | Documentation |
| --- | --- | --- |
| RealSense depth cameras that `realsense2_camera` supports, such as the D435 and the D435i | `realsense2_camera` of [`realsense-ros`](https://github.com/realsenseai/realsense-ros) | [docs/realsense.md](docs/realsense.md) |

## 🚀 Quick Start

1. Clone the device into `extensions/` of OpenRoSDE:

    ```shell
    git clone https://gitlab.com/coarobo/openrosde/openrosde-device-realsense.git extensions/openrosde-device-realsense
    ```

2. Activate it in `.env.custom`:

    ```shell
    OPENROSDE_ROBOT_EXTENSIONS="openrosde-device-realsense"
    ```

3. Build the images and the workspaces, which adds the Docker layer and the Catkin workspace of the device:

    ```shell
    bash ./BUILD-DOCKER-IMAGE.bash
    bash ./RUN-DOCKER-CONTAINER.bash
    openrosde-reset-catkin-workspaces
    ```

4. Start a camera in the container, with its serial number from `rs-enumerate-devices`:

    ```shell
    roslaunch openrosde_realsense_launch realsense_camera.launch camera:=camera serial_no:=<serial-number>
    ```

A setup usually activates the device in its template and starts its launch file from its own panes, as [`docs/extensions.md`](https://gitlab.com/coarobo/SDE/-/blob/dev/docs/extensions.md) of OpenRoSDE describes.

## 📁 Directory Structure

```
openrosde-device-realsense/
  ci/check-in-container.bash                         # Checks that the CI of OpenRoSDE runs in the container of a setup.
  docker/realsense-devel/Dockerfile                  # Docker layer: 'realsense2_camera' and 'realsense2_description'.
  docs/realsense.md                                  # Documentation of the device.
  ros/realsense_catkin_ws/src/
    openrosde_realsense_launch/                      # Launch file of one camera.
```

## 📖 Documentation

| Document | Content |
| --- | --- |
| [docs/realsense.md](docs/realsense.md) | Configuration, serial numbers, one and several cameras, USB controllers, and TF frames |
| [openrosde_realsense_launch](ros/realsense_catkin_ws/src/openrosde_realsense_launch/README.md) | Launch file and its arguments |

## 🧪 Testing

The pipeline of this repository clones OpenRoSDE on `dev`, adds this device to the `ur5e` setup, builds its Docker layer and its workspace on the published `ur5e-devel:dev` image, and runs `ci/check-in-container.bash` in a container without network.
That check resolves the launch file with `roslaunch --files` and `--dump-params`, which start no node, for a test camera with a made-up serial number.

## 🔗 External Resources

- OpenRoSDE: [https://gitlab.com/coarobo/SDE](https://gitlab.com/coarobo/SDE)
- Coarobo GK: [https://coarobo.com/](https://coarobo.com/)

## 🐛 Reporting Issues

Please report any issue using the GitLab issue tracker: [https://gitlab.com/coarobo/openrosde/openrosde-device-realsense/-/issues](https://gitlab.com/coarobo/openrosde/openrosde-device-realsense/-/issues).

## 🤝 Contributing

- This repository uses explicit commit messages following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.
- This project follows [Semantic Versioning](https://semver.org/) for releases.
- This project follows the conventions of OpenRoSDE, which its [`AGENTS.md`](https://gitlab.com/coarobo/SDE/-/blob/dev/AGENTS.md) describes.

## 👥 Authors & Acknowledgment

### 🔧 Maintainers

- **Lotfi El Hafi** (lotfi@coarobo.com)

### ✍️ Authors

- **Lotfi El Hafi**

## ⚖️ License

```
Copyright 2019 Coarobo GK

Licensed under the Apache License, Version 2.0
```

See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) for details, including the MIT License of the earlier version of the launch file in the SDE.

## 📜 Third-Party Software

| Component | Use | License |
| --- | --- | --- |
| [`realsense-ros`](https://github.com/realsenseai/realsense-ros) (`realsense2_camera`, `realsense2_description`) | Installed by the Docker layer from the ROS repositories | Apache License 2.0 |
| [`librealsense`](https://github.com/realsenseai/librealsense) | Installed with `realsense2_camera` from the ROS repositories | Apache License 2.0 |
