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
