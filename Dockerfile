FROM ros:humble-ros-base-jammy
SHELL ["/bin/bash", "-c"]

# install ros package dependencies
RUN sudo apt update &&\
	apt install python3-pip -y &&\
	apt install libgl1 -y &&\
	pip install opencv-python &&\
	pip install cv_bridge
	
RUN apt-get update && apt-get install -y \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav

RUN apt-get install -y \
    build-essential \
    cmake \
    git \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libgl1-mesa-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-dev


RUN cd /opt && \
    git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git && \
    cd opencv && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=Release \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
          -D WITH_GSTREAMER=ON \
          -D WITH_V4L=ON \
          -D WITH_OPENGL=ON \
          .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig



# install foxglove bridge

RUN sudo apt install ros-$ROS_DISTRO-foxglove-bridge -y

RUN mkdir -p ~/px4_ros_uxrce_dds/src &&\
	cd ~/px4_ros_uxrce_dds/src &&\
	git clone -b v2.4.2 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
	
RUN apt-get update && apt-get install -y nano

RUN mkdir -p ~/drone_ws/src/ &&\
    cd ~/drone_ws/src/ &&\
	git clone https://github.com/PX4/px4_msgs.git &&\
	git clone https://github.com/nheider/siyi_a8_ros2.git &&\
 	cd .. &&\
 	. /opt/ros/humble/setup.bash &&\
	colcon build 

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc &&\
    echo "source ~/drone_ws/install/setup.bash" >> ~/.bashrc

