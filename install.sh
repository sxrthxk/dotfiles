#!/usr/bin/env bash
set -e

echo "🚀 Starting dotfiles bootstrap..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Detected macOS"
  PKG_MANAGER="brew"
elif [[ -f "/etc/debian_version" ]]; then
  echo "Detected Debian/Ubuntu"
  PKG_MANAGER="apt"
else
  echo "❌ Unsupported OS. Exiting."
  exit 1
fi

# Install Homebrew if needed (macOS only)
if [[ "$PKG_MANAGER" == "brew" ]] && ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install required packages
if [[ "$PKG_MANAGER" == "brew" ]]; then
  brew install eza yazi zoxide tmux gh stow lazygit bat
elif [[ "$PKG_MANAGER" == "apt" ]]; then
  sudo apt update
  sudo apt install -y tmux unzip wget gh stow lazygit bat
  # eza, yazi, zoxide may need manual install if not in apt repos
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "🎨 Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
  ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use"
)

for plugin in "${!plugins[@]}"; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    echo "🔌 Installing $plugin..."
    git clone "${plugins[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# Install FiraCode Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -q "FiraCode Nerd Font"; then
  echo "🔤 Installing FiraCode Nerd Font..."
  wget -qO /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
  unzip -o /tmp/FiraCode.zip -d "$FONT_DIR"
  fc-cache -fv
fi

# Run stow on everything
echo "📦 Stowing all modules..."
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"
stow */

echo "✅ Setup complete!"
echo ""
echo "👉 Next steps:"
echo "1. Set 'FiraCode Nerd Font' in iTerm2 manually (Preferences → Profiles → Text)."
echo "2. Restart your terminal and enjoy 🎉"
