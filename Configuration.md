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
### Install necessary audio firmware and packages
1. (IF on a newer laptop that needs it only) Install sound open firmware `sudo pacman -S sof-firmware`
2. Install pipewire, pipewire-pulse, pavucontrol, and alsa-tools. `sudo pacman -S pipewire pipewire-pulse pavucontrol alsa-tools`
### Scaling with HiDPI Displays
1. Create (if it doesn't exist) a .profile with `touch ~/.profile` and edit it with `nvim ~/.profile`. Add these lines:
```
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
export QT_AUTO_SCREEN_SET_FACTOR=0
export QT_SCALE_FACTOR=2
export QT_FONT_DPI=96
```
2. Create (if it doesn't exist) a .Xresources with `touch ~/.Xresources` and edit it with `nvim ~/.Xresources`. Add these lines:
```
Xft.dpi: 192
Xcursor.size: 32
```
3. Reboot, and see the power of good scaling!
### Install unicode fonts
1. Install all noto fonts with `sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji`
2. Rebuild the font cache with `sudo fc-cache -f -v`
