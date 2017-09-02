#!/usr/bin/env bash

sudo useradd webapp

read -r -d '' SERVICE << SERVICE
[Unit]
Description=NodeJS WebApp example

[Service]
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=webapp
User=webapp
Group=webapp
ExecStart=/usr/bin/nodejs /opt/webapp/index.js

[Install]
WantedBy=multi-user.target
SERVICE

echo "$SERVICE" | sudo tee /etc/systemd/system/webapp.service
sudo systemctl enable webapp