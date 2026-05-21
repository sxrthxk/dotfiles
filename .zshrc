# ── Powerlevel10k instant prompt (keep near top) ─────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# ── fpath additions (must precede oh-my-zsh / compinit) ──────────────────────
fpath=("$HOME/.docker/completions" $fpath)

if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi

# ── oh-my-zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)
source "$ZSH/oh-my-zsh.sh"

# ── Core ──────────────────────────────────────────────────────────────────────
export EDITOR="nvim"

# ── Aliases ───────────────────────────────────────────────────────────────────
alias vi="nvim"
alias vim="nvim"
alias lg="lazygit"
alias cd="z"
alias li="eza -l --icons --git -a"
alias nrd="npm run dev"
alias npl="npm install --legacy-peer-deps"

# ── Functions ─────────────────────────────────────────────────────────────────
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

function mkcd() {
  mkdir -p "$1" && cd "$1"
}

function https-server() {
  http-server --ssl --cert ~/.localhost-ssl/localhost.crt --key ~/.localhost-ssl/localhost.key
}

# ── macOS-only ────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  # NVM via Homebrew
  export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && source "/usr/local/opt/nvm/nvm.sh"
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

  # Ruby via Homebrew
  export PATH="/usr/local/opt/ruby/bin:$PATH"
  export PATH="/usr/local/lib/ruby/gems/3.2.0/bin:$PATH"
  export PATH="$PATH:$HOME/.rvm/bin"

  # Android SDK
  export ANDROID_HOME="$HOME/Library/Android/sdk"

  # Java (Homebrew)
  export PATH="/usr/local/opt/openjdk@17/bin:$PATH"

  # TeX Live
  export PATH="/usr/local/texlive/2024/bin/universal-darwin:$PATH"

  # pnpm
  export PNPM_HOME="$HOME/Library/pnpm"

  # macOS-only aliases
  alias ring="afplay /System/Library/Sounds/Funk.aiff"
  alias nri="npm run ios -- --udid ED19F5E8-2610-46F0-BEB8-58E203971AF4"

# ── Linux / WSL2 ──────────────────────────────────────────────────────────────
else
  # NVM (standard Linux install)
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

  # Android SDK
  export ANDROID_HOME="$HOME/Android/Sdk"

  # pnpm
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi

# ── Shared PATH additions (use vars set above) ────────────────────────────────
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="/usr/local/go/bin:$PATH"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ── Tooling ───────────────────────────────────────────────────────────────────
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
[ -f "$HOME/.deno/env" ] && source "$HOME/.deno/env"

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"

# ── p10k ──────────────────────────────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
