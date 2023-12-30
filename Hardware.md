### Allow changes to backlight
1. Add user to video group with `sudo usermod -a -G video [username]`
2. Add backlight rule file with `sudo nvim /etc/udev/rules.d/99-backlight.rules`
3. Add the following lines to the file:
```
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```
4. Save and reboot
5. Change backlight with `echo [brightness] > sys/class/backlight/intel_backlight/brightness` (replace intel_backlight with your laptop-specific directory)
### Allow changes to battery threshold
Not all laptops support this function! Check if yours is compatible first.
1. Add battery rules file with `sudo nvim /etc/udev/rules.d/asus-battery-charge-threshold.rules`
2. Add the following line: `ACTION=="add", KERNEL=="asus-nb-wmi", RUN+="/bin/bash -c 'echo value > /sys/class/power_supply/BAT?/charge_control_end_threshold'"`
3. Reboot
4. To manually change it, issue this command: `echo 60 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold` replacing 60 with your desired value.
