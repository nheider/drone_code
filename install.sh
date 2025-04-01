# Install Docker
sudo apt update && sudo apt install -y docker.io

# Add docker group and add the current user to it
sudo groupadd docker
sudo usermod -aG docker $USER

# Apply new group membership (no need to log out/in)
newgrp docker

# Install curl for downloading additional packages
sudo apt install -y curl

# Add NVIDIA Container Toolkit repository and import GPG key
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

# Add the NVIDIA repository to the apt sources list
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update the package lists
sudo apt-get update

# Install NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit

# Configure Docker to use NVIDIA runtime by default
sudo nvidia-ctk runtime configure --runtime=docker

# Restart Docker service to apply changes
sudo systemctl restart docker

# Additional NVIDIA Container Toolkit configuration (optional)
sudo nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json

# Restart Docker service again to apply the new configuration
sudo systemctl restart docker

# Set no-cgroups option for the NVIDIA container runtime (optional)
sudo nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place

# Install Wi-Fi driver modules (adjust based on your hardware)
sudo apt install -y iwlwifi-modules

# Change ethernet speed to work with the siyi camera 

echo "Configuring Ethernet Speed..." 

sudo tee /etc/systemd/system/set-eth-speed.service > /dev/null <<EOL
 [Unit]
Description=Set Ethernet Speed 
After=network.target 

 [Service]
Type=oneshot
ExecStart=/sbin/ethtool -s enP8p1s0 speed 10 duplex full
RemainAfterExit=yes 

 [Install]
WantedBy=multi-user.target
EOL  

sudo systemctl daemon-reload 
sudo systemctl enable set-eth-speed.service 
sudo systemctl start set-eth-speed.service 

# Configure Network Settings to work withy Siyi Camera 
echo "Setting Static IP for Ethernet camera Network..." 

sudo tee /etc/netplan/01-network.yaml > /dev/null <<EOL 
network: 
	version: 2 
	renderer: networkd 
	ethernets: 
		enP8p1s0: 
			dhcp4: no 
			addresses: 
				- 192.168.144.10/24
			gateway4: 192.168.144.1 
			nameservers:
				addresses:
					- 8.8.8.8
					- 8.8.4.4
			dhcp6: no 
			ipv6: false 
EOL 

sudo netplan apply 

# Build the Docker image for ROS2 environment
docker build -t ros2_env .

# Run the Docker container with NVIDIA runtime and GPU support
docker run --runtime=nvidia --gpus all -it --rm --network host -v $(pwd):/workspace ros2_env

echo "reboot now" 
