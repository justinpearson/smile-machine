#!/bin/bash

read -p "This test exercises the stabber arm by sending 
the 'stab' and 'retract' commands to the PWM GPIO module. 
If the servo buzzes after the test completes, do this:
$ gpio -g pwm 18 101
$ gpio -g pwm 18 102
$ gpio -g pwm 18 103
... until it finds a servo position where the buzzing stops.
NOTE: Keep the PWM numbers between 100 and 150. Going above 150 may 
cause the arm to impact the cup and rip off the servo!
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
