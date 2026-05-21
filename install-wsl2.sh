#!/usr/bin/env bash
set -e

if [[ ! -f /etc/debian_version ]]; then
  echo "This script is for Debian/Ubuntu (WSL2) only. Exiting."
  exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Updating package index..."
sudo apt-get update -qq

# ── Core apt packages ────────────────────────────────────────────────────────

echo "==> Installing apt packages..."
sudo apt-get install -y \
  zsh tmux git curl wget unzip stow fontconfig \
  ripgrep fd-find fzf xclip \
  python3 python3-pip pipx \
  bat build-essential

# Ubuntu ships these with different names; create wrappers in ~/.local/bin
mkdir -p "$HOME/.local/bin"
command -v batcat &>/dev/null && ! command -v bat &>/dev/null \
  && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
command -v fdfind &>/dev/null && ! command -v fd &>/dev/null \
  && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"

# ── GitHub CLI ───────────────────────────────────────────────────────────────

if ! command -v gh &>/dev/null; then
  echo "==> Installing GitHub CLI..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update -qq && sudo apt-get install -y gh
fi

# ── Neovim (stable binary — apt version is too old for LazyVim) ──────────────

if ! command -v nvim &>/dev/null; then
  echo "==> Installing Neovim (stable)..."
  wget -qO /tmp/nvim.tar.gz \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
fi

# ── Lazygit ──────────────────────────────────────────────────────────────────

if ! command -v lazygit &>/dev/null; then
  echo "==> Installing lazygit..."
  LG_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
  wget -qO /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/download/v${LG_VERSION}/lazygit_${LG_VERSION}_Linux_x86_64.tar.gz"
  tar -C /tmp -xzf /tmp/lazygit.tar.gz lazygit
  sudo install /tmp/lazygit /usr/local/bin/lazygit
  rm /tmp/lazygit.tar.gz /tmp/lazygit
fi

# ── eza ──────────────────────────────────────────────────────────────────────

if ! command -v eza &>/dev/null; then
  echo "==> Installing eza..."
  EZA_VERSION=$(curl -fsSL "https://api.github.com/repos/eza-community/eza/releases/latest" \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
  wget -qO /tmp/eza.tar.gz \
    "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-musl.tar.gz"
  tar -C /tmp -xzf /tmp/eza.tar.gz ./eza
  sudo install /tmp/eza /usr/local/bin/eza
  rm /tmp/eza.tar.gz /tmp/eza
fi

# ── zoxide ───────────────────────────────────────────────────────────────────

if ! command -v zoxide &>/dev/null; then
  echo "==> Installing zoxide..."
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# ── yazi ─────────────────────────────────────────────────────────────────────

if ! command -v yazi &>/dev/null; then
  echo "==> Installing yazi..."
  YAZI_VERSION=$(curl -fsSL "https://api.github.com/repos/sxyazi/yazi/releases/latest" \
    | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
  wget -qO /tmp/yazi.zip \
    "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-x86_64-unknown-linux-musl.zip"
  unzip -q /tmp/yazi.zip -d /tmp/yazi-tmp
  sudo install "/tmp/yazi-tmp/yazi-x86_64-unknown-linux-musl/yazi" /usr/local/bin/yazi
  rm -rf /tmp/yazi.zip /tmp/yazi-tmp
fi

# ── thefuck ──────────────────────────────────────────────────────────────────

if ! command -v thefuck &>/dev/null; then
  echo "==> Installing thefuck..."
  pipx install thefuck
  pipx ensurepath
fi

# ── oh-my-zsh ────────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

# ── Powerlevel10k ────────────────────────────────────────────────────────────

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "==> Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# ── zsh plugins ──────────────────────────────────────────────────────────────

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A ZSH_PLUGINS=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
  ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use"
)
for plugin in "${!ZSH_PLUGINS[@]}"; do
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    echo "==> Installing zsh plugin: $plugin..."
    git clone --depth=1 "${ZSH_PLUGINS[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# ── FiraCode Nerd Font ───────────────────────────────────────────────────────

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -qi "FiraCode Nerd Font"; then
  echo "==> Installing FiraCode Nerd Font..."
  wget -qO /tmp/FiraCode.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
  unzip -q /tmp/FiraCode.zip -d "$FONT_DIR"
  fc-cache -fv >/dev/null
  rm /tmp/FiraCode.zip
fi

# ── tmux plugin manager ──────────────────────────────────────────────────────

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "==> Installing tmux plugin manager..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ── NVM ──────────────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.nvm" ]; then
  echo "==> Installing nvm..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# ── Stow dotfiles ────────────────────────────────────────────────────────────

echo "==> Stowing dotfiles..."
cd "$DOTFILES_DIR"

# oh-my-zsh installer may have created a ~/.zshrc; back it up so stow can link ours
[ -f "$HOME/.zshrc" ] && ! [ -L "$HOME/.zshrc" ] \
  && mv "$HOME/.zshrc" "$HOME/.zshrc.pre-stow.bak" \
  && echo "Backed up existing ~/.zshrc to ~/.zshrc.pre-stow.bak"

# Stow everything except macOS-only paths
stow --ignore='^Library$' \
     --ignore='^iterm_profile\.json$' \
     --ignore='^install.*\.sh$' \
     --ignore='^README\.md$' \
     -v .

# Lazygit config lives at Library/…/lazygit/config.yml (macOS convention).
# On Linux, lazygit expects ~/.config/lazygit/config.yml — symlink manually.
mkdir -p "$HOME/.config/lazygit"
LAZYGIT_SRC="$DOTFILES_DIR/Library/Application Support/lazygit/config.yml"
LAZYGIT_DST="$HOME/.config/lazygit/config.yml"
if [ ! -L "$LAZYGIT_DST" ] && [ -f "$LAZYGIT_SRC" ]; then
  ln -sf "$LAZYGIT_SRC" "$LAZYGIT_DST"
  echo "Symlinked lazygit config → $LAZYGIT_DST"
fi

# ── Default shell ────────────────────────────────────────────────────────────

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  echo "==> Setting zsh as default shell..."
  chsh -s "$(command -v zsh)"
fi

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Set 'FiraCode Nerd Font' in Windows Terminal"
echo "     (Settings -> Profile -> Appearance -> Font face)"
echo "  2. Start a new terminal session (zsh will load)"
echo "  3. In tmux: Ctrl+a then I  to install plugins"
echo "  4. ~/.zshrc has macOS-specific paths that won't resolve — clean those up"
echo "     or replace with a WSL2-specific version"
