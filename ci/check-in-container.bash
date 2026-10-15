#!/bin/bash

# This script checks the RealSense device inside the container of a setup that activates it, as part of the CI of OpenRoSDE.
# 'gitlab-ci/run-extension-checks.bash' of OpenRoSDE runs it once the Catkin workspaces of the setup are built and sourced, in a container without any network.
# It resolves every launch file of 'openrosde_realsense_launch' with 'roslaunch --files' and '--dump-params', which start no node, for a test camera with a made-up serial number, since no camera is connected.
#
# Usage: bash ./ci/check-in-container.bash <robot-setup>
#
# <robot-setup>: The setup whose container runs the check, such as 'ur5e'.

################################################################################

# Name the test camera, whose serial number matches no real camera.
OPENROSDE_REALSENSE_TEST_ARGUMENTS=(camera:=test_camera serial_no:=000000000000)

# Find the package of the device in the sourced workspaces.
OPENROSDE_REALSENSE_LAUNCH_DIR="$(rospack find openrosde_realsense_launch)"
if [ -z "${OPENROSDE_REALSENSE_LAUNCH_DIR}" ]; then
  echo "Error: The package 'openrosde_realsense_launch' is not in the sourced workspaces of the setup '$1'."
  exit 1
fi
echo "Checking the RealSense device in the setup '$1'."

################################################################################

# Resolve every launch file and dump its parameters, which starts no node and needs no ROS master, and check that the test camera takes the serial number.
OPENROSDE_REALSENSE_FAILED_CHECKS=""
for OPENROSDE_REALSENSE_LAUNCH_FILE in "${OPENROSDE_REALSENSE_LAUNCH_DIR}"/launch/*.launch; do
  if roslaunch --files "${OPENROSDE_REALSENSE_LAUNCH_FILE}" "${OPENROSDE_REALSENSE_TEST_ARGUMENTS[@]}" > /dev/null \
    && roslaunch --dump-params "${OPENROSDE_REALSENSE_LAUNCH_FILE}" "${OPENROSDE_REALSENSE_TEST_ARGUMENTS[@]}" | grep -q -x -F -e "/test_camera/realsense2_camera/serial_no: '000000000000'"; then
    echo "Resolved '$(basename "${OPENROSDE_REALSENSE_LAUNCH_FILE}")' for the test camera."
  else
    echo "Error: '$(basename "${OPENROSDE_REALSENSE_LAUNCH_FILE}")' does not resolve its files or its parameters for the test camera."
    OPENROSDE_REALSENSE_FAILED_CHECKS="${OPENROSDE_REALSENSE_FAILED_CHECKS}"$'\n'"  - $(basename "${OPENROSDE_REALSENSE_LAUNCH_FILE}")"
  fi
done

################################################################################

# Report the result, and fail if any check failed.
if [ -n "${OPENROSDE_REALSENSE_FAILED_CHECKS}" ]; then
  echo "These launch files of the RealSense device failed:${OPENROSDE_REALSENSE_FAILED_CHECKS}"
  exit 1
fi
echo "Every check of the RealSense device passed."
