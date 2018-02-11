#!/bin/bash

read -p "This test exercises the stabber arm by sending 
the 'stab' and 'retract' commands to the PWM GPIO module. 
Press enter to continue."

echo "Initializing PWM..."
gpio -g mode 18 pwm
gpio pwm-ms
gpio pwmc 192
gpio pwmr 2000
gpio -g pwm 18 100    # retract
echo "Done."

read -p "Ready to stab? (Push enter):"

echo "Stabbing 4 times!"

for i in `seq 1 4`;
do
    gpio -g pwm 18 150    # stab
    sleep .2
    gpio -g pwm 18 100    # retract
    sleep .2
done  

echo "Done stabbing."