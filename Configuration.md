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
7. For reference, i3 default config is located in `/etc/i3/config` but if you ran through the configuration at the start while logged in as your user it should create a user-defined config at ~/.config/i3/config
8. Configure your i3 as you wish with `nvim ~/.config/i3/config`
9. You can set the X server to start upon logon by running `nvim ~/.bash_profile` and appending this to the bottom of the file:
```
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
```
### Autologin
NOTE: Autologin presents a real security risk. Make sure you secure your system properly before attempting to add autologin routines.
1. Create a drop-in autologin configuration file with `systemctl edit getty@tty1.service --drop-in=autologin` and add the following below the first two lines: 
```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin [username] --noclear %I $TERM
```
2. Test the autologin with `reboot`
NOTE: You MAY need to run `systemctl enable getty@tty1` and then reboot
### Silent Boot
Do the following if you want to suppress grub messages, fsck filesystem messages, logged-in messages, and X server messages upon boot for a clean, black look all the way up until your window manager. This section does not contribute to functionality (in fact detracts from it) and so should only be performed for aesthetic reasons.
1. Make sure you're logged in as your user. Add a .hushlogin file to user's directory with `touch ~/.hushlogin` to silence the 'last login' message upon logging in.
2. Open .bash_profile with `nvim ~/.bash_profile` and replace the lines around exec startx with this line (or just append the line if there is no lines like that):
   `[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null`
3. Log in as root with the `su` command (avoids lots of sudoing for the next steps)
4. Replace hooks to prevent filesystem messages from showing up by typing `nvim /etc/mkinitcpio.conf` again and replace `udev` with `systemd` in the line that starts with `HOOKS=`
5. Regenerate the image with `mkinitcpio -P`
6. Edit fsck service with `systemctl edit --full systemd-fsck-root.service` and add these lines below `ExecStart`:
```
  StandardOutput=null
  StandardError=journal+console
```
In addition, change TimeoutSec to `TimeoutSec=0`
7. Make the same changes to `systemctl edit --full systemd-fsck@.service` 
8. Open grub's config at `nvim /boot/grub/grub.cfg` and comment out the lines (by adding # to the beginning of the lines) that say `echo 'Loading Linux linux...'` and `echo 'Loading initial ramdisk ...'` There are usually three sets of these for a single kernel installation.
     **NOTE: BE VERY CAREFUL WHEN EDITING THIS FILE AS BAD CHANGES CAN COMPLETELY PREVENT BOOT. THERE IS CURRENTLY NO WAY TO REMOVE THESE ECHOS SAFELY**
	 *NOTE 2: Whenever you change grub settings and reload the grub config, you will have to manually comment out these lines again.*
9. Reboot to see a clean, black slate of pure zen (also read as: terrifying lack of information)
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
