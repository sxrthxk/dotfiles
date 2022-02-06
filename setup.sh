#!/usr/bin/env bash

DIR="$HOME"

echo "Linking all config to their original spots..."
# Currently linking Rofi, i3 and polybar configs
mkdir $HOME/backup

mv "$HOME/.config/i3" "$HOME/backup/"
ln -nfs "$HOME/dotfiles/i3" "$HOME/.config/i3"
echo "Linked i3 config..."

mv "$HOME/.config/rofi" "$HOME/backup/"
ln -nfs "$HOME/dotfiles/rofi" "$HOME/.config/rofi"
echo "Linked Rofi config..."

mv "$HOME/.config/polybar" "$HOME/backup/"
ln -nfs "$HOME/dotfiles/polybar" "$HOME/.config/polybar"
echo "Linked Polybar config..."

mv "$HOME/.zshrc" "$HOME/backup/"
ln -nfs "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
echo "Linked zsh config..."

mv "$HOME/.config/konsolerc" "$HOME/backup/"
ln -nfs "$HOME/dotfiles/konsolerc" "$HOME/.config/konsolerc"
echo "Linked konsole complete"

echo "Task Completed!"

