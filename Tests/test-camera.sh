#!/bin/bash

read -p "
This test takes a picture hi.jpg from the camera, so you can verify the camera works.
To view it, you have 3 options:
1. run the RPi with a HDMI monior attached, then double-click on the picture to open it.
2. run ssh with -X and use the CLI command $ gpicview hi.jpg
3. copy the image to your laptop with scp:
    your-laptop$ scp pi@<ip addr>:/home/pi/smile-machine/hi.jpg . 
Push enter to take the picture.    
"

raspistill -w 320 -h 240 --nopreview -t 1 -o hi.jpg

echo "Done taking picture hi.jpg."
