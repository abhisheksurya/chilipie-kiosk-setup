#!/bin/bash
set -e

NODE_VERSION=v9.9.0

sudo apt-get update
sudo apt-get install -y git

cd $HOME

wget -O background.png https://bit.ly/2QdvF0w

if [ ! -d node-$NODE_VERSION-linux-armv7l ]; then
    wget https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-armv7l.tar.gz
    tar -xzf node-$NODE_VERSION-linux-armv7l.tar.gz
    (cd node-$NODE_VERSION-linux-armv7l; sudo cp -R * /usr/local)
fi

if [ ! -d node-build-monitor ]; then
    git clone --depth=1 https://github.com/jeppefrandsen/node-build-monitor
    (cd node-build-monitor; npm install)
fi

cat > $HOME/crontab << EOF
DISPLAY=:0.0

# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                       7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * *  command to execute

# Reboot the Pi every night at 3 AM to ensure smooth operation
0 3 * * * sudo reboot

# Turn display on weekdays at 7 AM
0 7 * * 1-5 ~/display-on.sh

# Turn display off weekdays at 7 PM (and after the nightly reboot)
0 19 * * 1-5 ~/display-off.sh
10 3 * * 1-5 ~/display-off.sh

# Reload webpage every hour
0 * * * * xdotool key ctrl+R

# Cycle between open tabs every 2 minutes
*/2 * * * * xdotool key ctrl+Tab
EOF
crontab $HOME/crontab

sudo su root << EOF
cat > /lib/systemd/system/node-build-monitor.service << EOF1
[Unit]
Description=node-build-monitor
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/local/bin/node $HOME/node-build-monitor/app/app.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF1
chmod 644 /lib/systemd/system/node-build-monitor.service
systemctl daemon-reload
systemctl enable node-build-monitor.service
EOF
