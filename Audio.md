### Pipewire, mpd, and ncmpcpp
1. Install pipewire, pipewire-pulse, pavucontrol, and alsa-tools. `sudo pacman -S pipewire pipewire-pulse pavucontrol alsa-tools`
2. Install mpd and ncmpcpp with `sudo pacman -S mpd ncmpcpp`
3. Create mpd config folder with `mkdir -p ~/.config/mpd`
4. Copy mpd config into user directory with `cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf`
5. Configure to work with pipewire by adding:
```
audio_output {
type		"pipewire"
name		"PipeWire Sound Server"
}
```
6. Finish the configuration as desired (for example, adding music directory and playlist directory)
7. Start mpd by including this in i3 config or similar startup location (i3 config in this example): `exec --no-startup-id [ ! -s ~/.config/mpd/pid ] && mpd`
(starting the mpd service globally reads the global config file ONLY for whatever reason)
8. Copy the ncmpcpp config files into user directory with `cp /usr/share/doc/ncmpcpp/config ~/.config/ncmpcpp/config`
9. Change the music directory in the config file to the directory you set in mpd.conf
10. Change ncmpcpp bindings by copying the default bindings and editing with `cp /usr/share/doc/ncmpcpp/bindings ~/.config/ncmpcpp/bindings`
