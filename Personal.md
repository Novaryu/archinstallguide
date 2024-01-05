### Install and Configure Firefox
1. Install firefox with `sudo pacman -S firefox` and select 2 for audio option
2. Configure:
    - Website appearance: Dark
    - Always ask you where to save files
    - Disable Ask to save logins and passwords for websites
    - Firefox will use custom settings for history
    - Clear history when firefox closes (uncheck cookies and active logins)
    - Uncheck all suggestions except for bookmarks
    - Uncheck allow firefox to send technical data and uncheck allow firefox to run studies
    - Uncheck provide search suggestions
    - Delete all search engines except active one from Search Shortcuts
    - Remove everything from homepage except for Web Search
3. Install the following addons:
    - Ublock Origin
    - Tab Session Manager
        - Configuration: uncheck both lazy loading checkboxes, uncheck save session regularly, change maximum number saved when window was closed/exiting browser to 5, change color scheme to dark
    - Custom search engine (i.e. Startpage or alternative)
    - Dark Reader
    - VimFx (Requires custom installation but WELL worth it)
### Install and configure git with github token
1. Run `sudo pacman -S git`
2. Run `git config --global user.name "Your Name"`
3. Run `git config --global user.email "your@email"`
4. Run `git config --global credential.helper store`
5. Clone a repository with `git clone [link]`
6. When it asks for username type your username
7. When it asks for password type your token
It should automatically store your token permanently on your device.
### Install a service to automatically run when suspended/resumed
1. Create a service with `sudo nvim /etc/systemd/system/sleep.service`
2. Add the following lines to the service:
```
[Unit]
Description=sleep hook
Before=sleep.target
StopWhenUnneeded=yes

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=-/usr/share/sleep/suspend.sh
ExecStop=-/usr/share/sleep/resume.sh

[Install]
WantedBy=sleep.target
```
3. Create your custom scripts in /usr/share/sleep/ with `sudo nvim /usr/share/sleep/suspend.sh` and `sudo nvim /usr/share/sleep/resume.sh`
4. Enable the service with `sudo systemctl enable sleep`
5. Reboot or start the service.
### Install Spotify with Spicetify + Add Extensions
1. Install pgp key with `curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | gpg --import -`
2. Install spotify dependencies with `sudo pacman -S libcurl-gnutls libayatana-appindicator`
3. Clone spotify repository with `git clone https://aur.archlinux.org/spotify.git`
4. cd into directory with `cd spotify`
5. Run `makepkg`
6. Install with `sudo pacman -U spotify-*.pkg.tar.zst`
7. Run SpotX-Bash patcher with `bash <(curl -sSL https://spotx-official.github.io/run.sh)` (removes banners/ads)
8. clone spicetify-cli with `git clone https://github.com/spicetify/spicetify-cli`
9. run the install script with `sudo ./install.sh`
10. run spicetify at least once by navigating to ~/.spicetify and running `./spicetify`
11. Put extensions (.js file) in .spicetify/extensions
12. Apply extension with `./spicetify config extensions [filename]` then run `./spicetify apply`
13. Repeat for other extensions (recommended: adblock.js, keyboardShortcut.js, popupLyrics.js, shuffle+.js, trashbin.js)
14. Apply themes if desired by adding a folder with the theme name in .spicetify/Themes and adding color.ini and user.css, then running `./spicetify config current_theme [theme]` followed by `./spicetify apply`
### Install speech narrator for notifications
1. Install speech dispatcher with `sudo pacman -S speech-dispatcher espeakup`
2. Configure it with `spd-conf`
3. Test it with `spd-say hello`
### Install Japanese Input
1. Install dependencies fcitx5+bazel with `sudo pacman -S fcitx5 fcitx5-qt fcitx5-gtk bazel`
2. Install dependency mozc by cloning `git clone https://aur.archlinux.org/mozc.git` and `cd mozc && makepkg && sudo pacman -U mozc-*.pkg.tar.zst`
3. Install fcitx5-mozc-ut from the AUR by cloning `git clone https://aur.archlinux.org/packages/fcitx5-mozc-ut.git`
4. Run `fcitx5-configtool` and add Mozc (Japanese) to the list of languages
5. Add the following to ~/.bashrc:
```
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```
6. Reboot and try Control+Space in terminal and browser
