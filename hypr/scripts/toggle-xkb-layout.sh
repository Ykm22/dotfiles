#!/usr/bin/env bash
current=$(hyprctl devices | grep -A 8 "at-translated-set-2-keyboard" | grep "active keymap" | grep -o "English\|Romanian")

if [[ "$current" == "English" ]]; then
    hyprctl switchxkblayout at-translated-set-2-keyboard 1
else
    hyprctl switchxkblayout at-translated-set-2-keyboard 0
fi
