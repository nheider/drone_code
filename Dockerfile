FROM ros:humble-ros-base-jammy

# install ros package dependencies
RUN sudo apt update &&\
	apt install python3-pip -y &&\
	apt install libgl1 -y &&\
	pip install opencv-python &&\
	pip install cv_bridge
	
# install foxglove bridge

RUN sudo apt install ros-$ROS_DISTRO-foxglove-bridge -y

RUN mkdir -p ~/px4_ros_uxrce_dds/src &&\
	cd ~/px4_ros_uxrce_dds/src &&\
	git clone -b v2.4.2 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
	
RUN apt-get update && apt-get install -y nano

SHELL ["/bin/bash", "-c"]
RUN mkdir -p ~/drone_ws/src/ &&\
    cd ~/drone_ws/src/ &&\
	git clone https://github.com/PX4/px4_msgs.git &&\
	git clone https://github.com/nheider/siyi_a8_ros2.git &&\
 	cd .. &&\
 	. /opt/ros/humble/setup.bash &&\
	colcon build 

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc &&\
    echo "source ~/drone_ws/install/setup.bash" >> ~/.bashrc

