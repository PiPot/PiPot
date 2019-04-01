# PiPot (Micro Honeypot for RPi) - Main repository

PiPot (Micro Honeypot for RPi) is a flexible honeypot for (industrial) 
environments that runs on a Raspberry Pi. It was developed by Willem Van 
Iseghem for the Master thesis at the 
[Fachhochschule St. Pölten](https://www.fhstp.ac.at/) in 2016. [Limes Security
GmbH](https://www.limessecurity.com) sponsored the thesis by providing the 
necessary hardware.

This repository is meant for centralizing issues and enhancement proposals, as
well as documentation on how to install and run PiPot.

## Contributing

Please read [CONTRIBUTING](.github/CONTRIBUTING.md) before making any 
contributions.

## Installation

Installing PiPot is pretty straightforward:

* Copy or clone the entire `pipot-server` and `pipot-client` repositories to 
`/usr/src/pipot` (so the respective locations would be `/usr/src/pipot/server`
and `/usr/src/pipot/client`).
* (Optional) `chmod +x /usr/src/pipot/server/install/install.sh`
* (Optional, for image generation) `chmox +x /usr/src/pipot/client/bin/chroot.sh`
* `/usr/src/pipot/server/install/install.sh` (execute as root or use `sudo`)
* Answer any questions the installer asks
