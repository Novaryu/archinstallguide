### (Wireless) Connect to an access point
1. Run `wifi-menu` and select the access point you want to connect to and enter the passphrase when prompted. Change the default name to something that's easier to type
2. It should connect to the access point automatically. You can test with `ping archlinux.org`
3. To allow automatic connection to this access point on boot, enter `netctl enable [name]`, replacing the name with the name you chose for your access point.
4. ALTERNATIVELY, if you use multiple access points and want netctl to handle automatic switching when changing location, enable the netctl-auto service with `systemctl enable netctl-auto@wlo1`making sure to replace 'wlo1' with your interface, found via `ip link`. Do NOT run `netctl enable [name]` in this situation as it will try to connect twice.
### Create your default user and add to sudoers
1. Create your desired user with `useradd --create-home [username]`, replacing `[username]` with your user's desired name
2. Set a password for your user with `passwd [username]`
3. Install sudo with `pacman -S sudo`
4. Add user to Sudo group with `usermod -aG wheel [username]`
5. Edit the sudoers file with `visudo` (replace nvim with your editor)
6. Uncomment the line (remove the #) that says `%wheel ALL=(ALL:ALL) ALL` then save and exit
7. Test your ability to sudo properly by logging in with `logout` then logging in as your user. Once logged in, try `sudo pacman -Syu` to make sure sudo works
8. `logout` and re-enter root's login
### Install a window manager (i3 in this example)
1. Run `pacman -S xorg-server xorg-xinit` to install Xorg and necessary addons.
2. Run `pacman -S i3-wm` and when it asks what fonts you want select `2 (noto-fonts)`or whatever font pack you want.
3. Install your favorite terminal with `pacman -S alacritty` replacing alacritty with your terminal
4. Open `nvim /etc/X11/xinit/xinitrc` and comment these lines out (add # at the beginning): 
```
twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &
exec xterm -geometry 80x66+0+0 -name login
```
And add this to the bottom of the file: `exec i3`

5. Now log in as your user and try `startx`. It should grab the system defaults and launch into i3. It will ask you if you want to configure, and you can follow the prompts as you please. (You can quit i3 by hitting Ctrl+Alt+E and clicking "Yes, exit i3")
6. Copy the xorg config file into your user directory and call it .xinitrc by executing `sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc` This allows you to make changes for each user that won't affect root.
For reference, i3 default config is located in `/etc/i3/config` but if you ran through the configuration at the start while logged in as your user it should create a user-defined config at ~/.config/i3/config
7. Configure your i3 as you wish with `nvim ~/.config/i3/config`
8. You can set the X server to start upon logon by running `nvim ~/.bash_profile` and appending this to the bottom of the file:
```
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
```
### Install a status line (polybar in this example)
1. Run `pacman -S polybar`
2. Create a config directory with `mkdir ~/.config/polybar`
3. Copy the config file into your config directory with `cp /etc/polybar/config.ini ~/.config/polybar/config.ini`
4. Create a polybar launch script using `touch ~/bin/launch_polybar.sh`
5. Add the following to launch_polybar.sh:
```
#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar mybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
```
6. Make it executable with `chmod +x ~/bin/launch_polybar.sh`
7. Add the following line to i3 config: `exec_always --no-startup-id ~/bin/launch_polybar.sh`
The `exec_always` command tells i3 to reload polybar whenever i3 is reloaded (don't have to explicitly restart polybar)
8. Reload i3 with alt+shift+r (default keybind)
9. Configure polybar as needed with nvim `~/.config/polybar/config.ini`
