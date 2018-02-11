#!/bin/bash

read -p "
This test takes a picture from the camera. 
To view it, you can either run the RPi with a HDMI monior attached, 
or use scp to copy the image to your laptop:
    your-laptop$ scp pi@<ip addr>:/home/pi/smile-machine/hi.jpg . 
Push enter to take the picture.    
"

raspistill -w 320 -h 240 --nopreview -t 1 -o hi.jpg

echo "Done taking picture hi.jpg."
