# chilipie-kiosk-setup

Script for help setting up [node-build-monitor](https://github.com/marcells/node-build-monitor) on [chilipie-kiosk](https://github.com/futurice/chilipie-kiosk).

1. [Install chilipie-kiosk](https://github.com/futurice/chilipie-kiosk#getting-started)
2. Insert a keyboard to the Raspberry Pi and power it on
3. Setup network and enable SSH using `raspi-config` by pressing `Ctrl + Alt + F2`
4. Login to the Raspberry Pi using `ssh -l pi <IP address>` and password `raspberry`
5. Run: `bash <(curl -s https://raw.githubusercontent.com/bang-olufsen/chilipie-kiosk-setup/master/setup.sh)`
6. Change the `$HOME/node-build-monitor/app/config.json` for the used build system
7. Power cycle the Raspberry Pi
8. [Set the URLs](https://github.com/futurice/chilipie-kiosk/blob/master/docs/first-boot.md#setting-the-url). The node-build-monitor can be seen by using `http://localhost:3000`
