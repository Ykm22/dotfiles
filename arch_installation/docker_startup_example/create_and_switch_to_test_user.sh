#!/bin/bash
set -e
set -x

if [ -z "$USER_NAME" ] || [ -z "$USER_PASSWORD" ]; then
  echo "Error: USER_NAME or USER_PASSWORD environment variables are not set."
  exit 1
fi

pacman -Sy --noconfirm sudo

useradd -m -G users "$USER_NAME"
echo "$USER_NAME:$USER_PASSWORD" | chpasswd

usermod -aG wheel "$USER_NAME"
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >>/etc/sudoers

chown -R "$USER_NAME":"$USER_NAME" /home/"$USER_NAME"

chmod +x "./install_pacman_pkgs.sh"
chmod +x "./add_yay.sh"
chmod +x "./install_yay_pkgs.sh"

exec su -l "$USER_NAME"
