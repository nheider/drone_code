#!/bin/bash 

set -e 

source /opt/ros/humble/setup.bash
source /workspace/install/setup.bash # To do see if this is correct 

echo "Starting Micro XRCE-DDS Agent..." 

MicroXRCEAgent serial --dev /dev/tty/THS1 -b 921600

echo "Changing Ethernet for Camera Connection" 

sudo ethtool -s enP8p1s0 speed 10 duplex full 

 

