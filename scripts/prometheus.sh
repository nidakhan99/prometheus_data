#!/bin/bash
set -e 

#----------------------updating system----------------
echo "step 1"
echo "Updating the system !"
sudo apt update

#--------------------craetion of user and group----------------
echo "step 2"
echo " creating group Prometheus and adding user to it"
username="prometheus"
if getent passwd "$username" > /dev/null; then
echo "User exists"
else
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
fi

#------------------------Making directories -----------------------------
echo "step 3"
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

#------------------------Download and extarcting prometheus file-----------------------------
echo "step 4"
wget https://github.com/prometheus/prometheus/releases/download/v2.43.0/prometheus-2.43.0.linux-amd64.tar.gz
echo "step 5"
tar -xzvf prometheus-2.43.0.linux-amd64.tar.gz

#------------------------move to prometheus directory-----------------------------
echo "step 6"
cd prometheus-2.43.0.linux-amd64

#-------------------------Move the Binary Files & Set Owner---------------------------
echo "step 7"
sudo mv prometheus /usr/local/bin
sudo mv promtool /usr/local/bin
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool


#-------------------------Move the Configuration Files & Set Owner---------------------------
echo "step 8"
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /var/lib/prometheus

#-------------------------Create Prometheus Systemd Service---------------------------
echo "step 9"
path="/etc/systemd/system/prometheus.service"
sudo touch "${path}"
echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target" > "${path}"


#-------------------------Reload Systemd---------------------------
echo "step 10"
sudo systemctl daemon-reload


#-------------------------Reload Systemd---------------------------
echo "step 10"
sudo systemctl daemon-reload


#------------------------Start Prometheus Service--------------------
echo "step 11"
sudo systemctl enable prometheus
sudo systemctl start prometheus
