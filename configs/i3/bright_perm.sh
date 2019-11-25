#!/bin/sh

i3-input | grep output | cut -d'=' -f 2 | cut -d' ' -f 2 | sudo -S chmod a+w /sys/class/backlight/acpi_video0/brightness
