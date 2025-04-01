FROM ros:humble-ros-base-jammy

RUN mkdir -p ~/px4_ros_uxrce_dds_ws/src &&\
	cd ~/px4_ros_uxrce_dds_ws/src &&\
	git clone -b v2.4.2 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
	
RUN apt-get update && apt-get install -y nano

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc &&\
    echo "source install/local_setup.bash" >> ~/.bashrc

