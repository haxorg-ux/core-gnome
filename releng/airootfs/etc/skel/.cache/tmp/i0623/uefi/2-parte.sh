#!/bin/bash
#
# Part 2/2
# Another installation method programmed through a custom script
# prepared for File System BTRFS with subvolume creation and udev
# zram rule for swap, but completely customizable according to the needs of your machine.

# settings script 2

localhost="localhost" # Nombre de máquina - hostname

user="username" # username [only lowercase] -- solo minúsculas
realname="realname" # real name [uppercase/lowercase] -- Nombre real [Mayúsculas/minúsculas]
rootpw="password" # root password
userpw="password" # user password

localegen="en_US.UTF-8 UTF-8" # locale encoding
localeconf="LANG=en_US.UTF-8" # local language
km="us" # keyboard layout

localtime="Europe/Madrid" # localtime

ZS="3G" # size swap zram

groups="wheel" # add groups for user

Ntools="wpa_supplicant wireless_tools netctl net-tools iw networkmanager" # set network tools
Audio="alsa-utils pipewire-pulse" # Audio packages

Utils="mtools dosfstools exfatprogs fuse" # tools 
PKGS="firewalld acpi cronie git reflector bluez bluez-utils neovim" #general packages -- options add packages

DE="xorg gnome-shell nautilus gnome-console gvfs gnome-control-center xdg-user-dirs-gtk  gnome-text-editor gnome-keyring gnome-system-monitor" #GNOME [Minimal installation] -- plasma-desktop konsole dolphin dolphin-plugins ffmpegthumbs ark okular gwenview kscreen kcalc kate kde-gtk-config spectacle firefox sddm sddm-kcm kmix
DM="gdm" # Display Manager

Service="gdm NetworkManager firewalld bluetooth cronie reflector" # Service

# [root=/dev/XXX] descomentar la nomenclatura uso systemd-boot IMPORTANTE! -- uncomment the nomenclature in use for systemd-boot IMPORTANT!

#p="sda2"
#p="vda2"
#p="nvme0n1p2"

# end setting ----------------------------------------------

ln -sf /usr/share/zoneinfo/$localtime /etc/localtime
hwclock --systohc
echo "$localegen" >/etc/locale.gen
locale-gen
echo "$localeconf" >>/etc/locale.conf
echo "KEYMAP=$km" >>/etc/vconsole.conf
echo "$localhost" >/etc/hostname
echo "127.0.0.1 localhost" >>/etc/hosts
echo "::1       localhost" >>/etc/hosts
echo root:$rootpw | chpasswd
useradd -m $user
echo $user:$userpw | chpasswd
usermod -aG $groups $user
usermod -c "$realname" $user
echo "$user ALL=(ALL:ALL) ALL" >>/etc/sudoers.d/$user
#echo "$user ALL=NOPASSWD: /usr/bin/pacman" >> /etc/sudoers.d/$user
#echo "$user ALL=NOPASSWD: /usr/bin/yay" >> /etc/sudoers.d/$user
#echo "$user ALL=NOPASSWD: /usr/bin/vim" >> /etc/sudoers.d/$user

#systemd-boot
pacman -S efibootmgr --noconfirm
bootctl --path=/boot install
echo "default arch-*" >>/boot/loader/loader.conf
echo "timeout 3" >>/boot/loader/loader.conf
echo "title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=/dev/"$p" rootflags=subvol=@ rw quiet loglevel=3 rd.system.show_status=auto rd.udev.log_level=3" >/boot/loader/entries/arch.conf

#zram udev rules
echo "zram" >/etc/modules-load.d/zram.conf
echo 'ACTION=="add", KERNEL=="zram0", ATTR{comp_algorithm}="zstd", ATTR{disksize}="'$ZS'", RUN="/usr/bin/mkswap -U clear /dev/%k" , TAG+="systemd"' >/etc/udev/rules.d/99-zram.rules
echo "/dev/zram0 none swap defaults,pri=100 0 0 " >>/etc/fstab

pacman -S $Ntools $Utils $Audio $PKGS $DE $DM --noconfirm

systemctl enable $Service

rm -r /home/2-parte.sh #clear
