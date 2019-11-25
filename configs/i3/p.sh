#!/bin/sh

i3-input | grep output | cut -d'=' -f 2 | cut -d' ' -f 2 | sudo chmod a+x ~/.config/i3/test
