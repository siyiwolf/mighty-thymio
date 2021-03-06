#!/usr/bin/env bash

# https://docs.docker.com/install/linux/docker-ce/ubuntu/

export LC_ALL=C

printf "\n****** Installing Docker ****** \n"

apt-get install  -y \
   apt-transport-https \
   ca-certificates \
   curl \
   git-core \
   software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update
apt install docker-ce -y || :
yes | apt remove apparmor
yes | apt autoremove

# https://docs.docker.com/compose/install/#install-compose

printf "\n****** Install docker compose ******\n"

apt install python3-pip -y
python3 -m pip install --upgrade pip
python3 -m pip install docker-compose

printf "\n****** Docker installation done ******\n"


#https://wiki.odroid.com/accessory/connectivity/wifi/wlan_ap

printf "\n****** Install hostapd and dnsmasq ****** \n"

apt install --reinstall dnsmasq -y
apt install hostapd iptables wpasupplicant -y

cp /usr/sbin/hostapd /usr/sbin/hostapd.back
cp ./hostapd /usr/sbin/hostapd
chmod +x /usr/sbin/hostapd

ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

printf "\n****** Create wlan  and shutdown FIFOs ****** \n"

mkfifo /root/docker/mighty-thymio/wlan
mkfifo /root/docker/mighty-thymio/shutdown
mkfifo /root/docker/mighty-thymio/update

chmod +x ../wlan.sh
chmod +x ../shutdown.sh
chmod +x ../update.sh

printf "\n****** Install ZRAM ******\n"

apt install zram-config

printf "\n****** Run the config script ******\n"

source setup.sh

cd ..
