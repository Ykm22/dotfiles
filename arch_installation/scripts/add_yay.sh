#!/bin/bash
sudo pacman -Sy --needed --noconfirm base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
