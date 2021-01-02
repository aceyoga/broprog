#!/bin/bash

sudo apt-get --purge remove linux-sound-base alsa-base alsa-utils
sudo apt-get install linux-sound-base alsa-base alsa-utils alsa-firmware-loaders alsa-oss alsa-source alsa-tools
sudo apt-get install dkms build-essential linux-headers-$(uname -r)
crontab -l > /home/user/broprog/jobs.txt
cron /home/user/broprog/jobs.txt