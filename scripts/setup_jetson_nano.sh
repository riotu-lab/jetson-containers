#!/usr/bin/env bash

# configure dialout group

# Add docker group and user to it
echo " " && echo "Docker configuration ..." && echo " "
sudo groupadd docker
sudo gpasswd -a $(whoami) docker

# Adjust serial port permissions
echo " " && echo "Serial ports configuration (ttyTHS1) ..." && echo " "
sudo usermod -aG dialout $(whoami)
sudo usermod -aG tty $(whoami)
sudo chmod 666 /dev/ttyTHS1

# clone jetson-containers repo
if [ ! -d "${HOME}/src" ]; then
    echo " " && echo "Creating src folder in HOME..." && echo " " && sleep 1
    cd ${HOME}
fi

if [ ! -d "${HOME}/src/jetson-containers" ]; then
    echo " " && echo "Cloning jetson-containers ..." && echo " " && sleep 1
    cd ${HOME}/src
    git clone https://github.com/mzahana/jetson-containers.git
else
    echo " " && echo "jetson-containers alredy exist in $HOME/src . Pulling latest from Github repo..." && echo " " && sleep 1
    cd ${HOME}/src/jetson-containers
    git pull
fi

cd $HOME/src/jetson-containers

echo " " && echo "Building $HOME/src/jetson-containers/Dockerfile.ros.melodic.px4 ..." && echo " " && sleep 1
./scripts/docker_build_ros_px4.sh

echo " " && echo "Adding alias to .bashrc script ..." && echo " "
grep -xF "alias px4_container='source \$HOME/src/jetson-containers/scripts/docker_run_px4.sh'" ${HOME}/.bashrc || echo "alias px4_container='source \$HOME/src/jetson-containers/scripts/docker_run_px4.sh'" >> ${HOME}/.bashrc

echo " " && echo "#------------- You can run the px4 container from the terminal by executing px4_container -------------#" && echo " "

cd $HOME

echo "#------------- Please reboot your Jetson Nano for some changes to take effect -------------#" && echo "" && echo " "