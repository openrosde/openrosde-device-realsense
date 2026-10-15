# General guidelines and recommendations for writing 'Dockerfile':
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

################################################################################

# Inherit from the image below this layer, given by 'BUILD-DOCKER-IMAGE.bash' of OpenRoSDE.
ARG OPENROSDE_PARENT_IMAGE
FROM ${OPENROSDE_PARENT_IMAGE}

################################################################################

# Install the RealSense cameras ROS dependencies.
# https://github.com/realsenseai/realsense-ros

# Gather the RealSense camera packages from the ROS repositories.
RUN apt-get update && apt-get install -y --no-install-recommends \
  ros-noetic-realsense2-camera \
  ros-noetic-realsense2-description \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

################################################################################

# Embed the commit hash of this Dockerfile for traceability.
ARG OPENROSDE_DOCKERFILE_COMMIT_SHORT_SHA
