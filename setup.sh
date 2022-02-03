#!/usr/bin/env bash

DIR="$HOME"

echo "Linking all config to their original spots..."
# Currently linking Rofi, i3 and polybar configs

ln -nfs "$HOME/dotfiles/i3" "$HOME/.config/i3"
echo "Linked i3 config..."

ln -nfs "$HOME/dotfiles/rofi" "$HOME/.config/rofi"
echo "Linked Rofi config..."

ln -nfs "$HOME/dotfiles/polybar" "$HOME/.config/polybar"
echo "Linked Polybar config..."

echo "Task Completed!"

