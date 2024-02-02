# Installation
From USB to Arch command line.
### Booting into the live environment
1. Download an ISO from https://archlinux.org/download/
2. Create bootable media with Rufus (Windows, can leave all settings default) or another program
3. Boot into the media to launch the Arch live environment (may need to set your BIOS default boot to the USB)
4. Check the UEFI bitness with:
   `cat /sys/firmware/efi/fw_platform_size`
   It should output 32 or 64.
### Connect to the internet
1. Find the network interface with `ip link`
2. Set it to up with `ip link set [device] up`, replacing `[device]` with the interface found in the previous step
3. Wired internet should automatically connect, test with `ping archlinux.org` and quit with Ctrl-C
#### (Wireless) Connect to an access point
enter `iwctl`and perform the following commands (replacing `[device]` with your wireless device found in `device list`):
```
iwctl
device list
device [device] set-property Powered on
station [device] scan
station [device] get-networks
station [device] connect [SSID]
```
4. Test your connection with `ping archlinux.org`
5. Confirm system time updated with `timedatectl` (It will be in UTC, we will change this later)
### Disk Partitioning
1. List all disks with `fdisk -l`
2. Enter the desired disk with `fdisk /dev/[device]`, replacing `[device]` with your listed device from fdisk
3. Delete all existing partitions with `d` followed by the number (repeat until no partitions)
4. Create a new partition with `n`
5. Specify the partition number as one (default) and leave the first sector as default. The last sector should be `+1G` or your desired EFI size.
6. Set the partition to an EFI system partition with `t` (set it to 1)
7. Do the same with another partition (also last sector set to `+1G` or your desired SWAP size)
8. Set the partition to a SWAP partition with t (find SWAP with -L)
9. Do the same with another partition, but leave the last sector as default (the remainder of the drive)
10. Set the partition to a Linux Filesystem partition with t (find Linux Filesystem with -L)
11. Save changes and quit fdisk with `w`
### Disk Formatting
Replace `[partition#]`below with the actual partition, again found via `fdisk -l`
1. Format the EFI partition with `mkfs.fat -F 32 /dev/[partition1]`
2. Format the Swap partition with `mkswap /dev/[partition2]`
3. Format the Linux partition with `mkfs.ext4 /dev/[partition3]`
### Mount Filesystems
1. Mount linux with `mount /dev/[partition3] /mnt`
2. Mount EFI with `mount --mkdir /dev/[partition1] /mnt/boot`
3. Mount swap with `swapon /dev/[partition2]`
### Install and Enter Linux
1. Install linux with `pacstrap -K /mnt base linux linux-firmware`  
NOTE: (If it fails with a PGP key error, update pacman keys with `pacman-key --refresh-keys`)
2. Generate fstab with `genfstab -U /mnt >> /mnt/etc/fstab`
3. Chroot into system `arch-chroot /mnt`
### Configure Linux
1. Install your favorite editor (neovim in this example) `pacman -S neovim`
2. Make your editor the default system editor with `echo 'EDITOR=nvim' | tee -a /etc/environment`
3. Set the root password with `passwd`, following the prompts
#### (Wired) Setup network service
1. Install necessary tools with `pacman -S netctl dhcpcd`
2. Find your network card with `ip link`
3. Enable your network card with `systemctl enable dhcpcd@eth0.service`, replacing eth0 with your card's identifier
#### (Wireless) Setup wireless service
1. Install necessary tools with `pacman -S netctl dialog wpa_supplicant dhcpcd`
2. Enable the resolved service with `systemctl enable systemd-resolved.service`
### Configure Bootloader
1. Install GRUB packages with `pacman -S grub efibootmgr`
2. Mount the EFI system partition (list with fdisk -l and find the first partition of the disk you previously partitioned) with `mkdir /efi` followed by `mount /dev/[partition1] /efi`
3. Install GRUB itself with `grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=GRUB`
4. Generate the GRUB configuration file with `grub-mkconfig -o /boot/grub/grub.cfg`
5. Reboot and remove the USB install media. It should (hopefully) display the GRUB menu and allow you to boot into your fresh arch linux install!
