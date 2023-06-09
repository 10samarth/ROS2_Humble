# Use Ubuntu 20.04 as base image
FROM ubuntu:22.04

# Set environment variables
ENV ROS_DISTRO humble
ENV DEBIAN_FRONTEND noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    sudo \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set up ROS2 sources and keys
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install ROS2 dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libopencv-dev \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-serial \
    python3-vcstool \
    python3-setuptools \
    ros-humble-desktop \
    ros-humble-ros-base \
    && rm -rf /var/lib/apt/lists/*


# Initialize rosdep
RUN rosdep init && rosdep update

# Create a new workspace
RUN mkdir -p /root/ros2_ws/src
WORKDIR /root/ros2_ws

# Clone the repository and build the code
RUN git clone https://github.com/10samarth/ROS2_Drive src/ROS2_Humble
RUN rosdep install --from-paths src --ignore-src -y
RUN colcon build

# Source ROS2 setup file
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Set up the entry point
CMD ["bash"]
