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
