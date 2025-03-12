#!/bin/bash
#
# Part 2/2
# Another installation method programmed through a custom script
# prepared for File System Bios

# settings script 2

localhost="localhost" # nombre de máquina - hostname

user="username" # username [only lowercase] -- solo minúsculas
realname="realname"  # real name [uppercase/lowercase]

rootpw="password" # root password
userpw="password" # user password

localegen="en_US.UTF-8 UTF-8" # locale encoding
localeconf="LANG=en_US.UTF-8" # local language

km="us" # keyboard layout
localtime="Europe/Madrid" # localtime

groups="wheel" # add groups for user
Ntools="wpa_supplicant wireless_tools netctl net-tools iw networkmanager" # set network tools

Audio="alsa-utils pipewire-pulse" # Audio packages
Utils="mtools dosfstools exfatprogs fuse" # tools

PKGS="firewalld acpi cronie git reflector bluez bluez-utils neovim" # general packages -- add more packages

DE="xorg gnome-shell nautilus gnome-console gvfs gnome-control-center xdg-user-dirs-gtk  gnome-text-editor gnome-keyring gnome-system-monitor" #GNOME [Minimal installation] -- plasma-desktop konsole dolphin dolphin-plugins ffmpegthumbs ark okular gwenview kscreen kcalc kate kde-gtk-config spectacle firefox sddm sddm-kcm kmix
DM="gdm" # Display Manager

Service="gdm NetworkManager firewalld bluetooth cronie reflector" # Service

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

#Grub Bios version

pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/your-nomenclature
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S $Ntools $Utils $Audio $PKGS $DE $DM --noconfirm

systemctl enable $Service

rm -r /home/2-parte.sh #clear
