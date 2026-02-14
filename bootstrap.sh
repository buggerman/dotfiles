#!/usr/bin/env bash
# -------------------------------------------------------------------
# buggerman's dotfiles bootstrap for macOS
# Installs Homebrew + core tools, then symlinks configs.
# Idempotent: safe to re-run.
# -------------------------------------------------------------------

set -euo pipefail

# Where this repo lives (override by running: DOTFILES_DIR=/path bash bootstrap.sh)
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

echo "→ Using DOTFILES_DIR=$DOTFILES_DIR"
[ -d "$DOTFILES_DIR" ] || { echo "✖ DOTFILES_DIR not found"; exit 1; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "✖ This bootstrap targets macOS only."
  exit 1
fi

echo "→ Ensuring Homebrew is installed"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "→ Updating Homebrew"
brew update

echo "→ Installing core CLI tools and applications"
brew install git uv fnm direnv eza bat ripgrep starship neovim

echo "→ Installing GUI applications"
brew install --cask ghostty neovide || true

echo "→ Installing Nerd Fonts"
brew tap homebrew/cask-fonts
brew install --cask font-monaspace-neon-nerd-font || true
brew install --cask font-jetbrains-mono-nerd-font || true

# Create config dirs
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/starship"
mkdir -p "$HOME/.config/uv"
mkdir -p "$HOME/.config/ghostty/shaders"
mkdir -p "$HOME/.config/neovide"
mkdir -p "$HOME/.config/nvim/lua"

# Link files from repo if they exist
link() {
  local src="$1"
  local dst="$2"
  if [ -e "$src" ]; then
    echo "→ Linking $dst → $src"
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
  else
    echo "• Skipping: $src not found"
  fi
}

# Expected repo layout:
# dotfiles/
#   zsh/.zshrc
#   config/starship/starship.toml
#   config/uv/config.toml (optional; generated if missing)
#   .ripgreprc (optional)

link "$DOTFILES_DIR/zsh/.zshrc"                           "$HOME/.zshrc"
link "$DOTFILES_DIR/config/starship/starship.toml"        "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/.ripgreprc"                           "$HOME/.ripgreprc"
link "$DOTFILES_DIR/config/ghostty/config"                "$HOME/.config/ghostty/config"
link "$DOTFILES_DIR/config/ghostty/shaders/neovide.glsl"  "$HOME/.config/ghostty/shaders/neovide.glsl"
link "$DOTFILES_DIR/config/neovide/config.toml"           "$HOME/.config/neovide/config.toml"
link "$DOTFILES_DIR/config/nvim/lua/neovide_settings.lua" "$HOME/.config/nvim/lua/neovide_settings.lua"
link "$DOTFILES_DIR/config/uv/config.toml"                "$HOME/.config/uv/config.toml"

# Clone NvChad starter if not already present
if [ ! -d "$HOME/.config/nvim/.git" ]; then
  echo "→ Cloning NvChad starter"
  git clone https://github.com/NvChad/starter "$HOME/.config/nvim"
  # Link our custom neovide_settings.lua
  link "$DOTFILES_DIR/config/nvim/lua/neovide_settings.lua" "$HOME/.config/nvim/lua/neovide_settings.lua"
else
  echo "• Neovim config already exists, skipping clone"
fi

# Clone ghostty-cursor-shaders if not already present
if [ ! -d "$HOME/.config/ghostty/shaders/ghostty-cursor-shaders" ]; then
  echo "→ Cloning ghostty-cursor-shaders"
  git clone https://github.com/sahaj-b/ghostty-cursor-shaders "$HOME/.config/ghostty/shaders/ghostty-cursor-shaders"
else
  echo "• Ghostty cursor shaders already exist, skipping clone"
fi

# Ensure uv default Python (3.14) if user doesn't have a config yet
UV_CFG="$HOME/.config/uv/config.toml"
if [ ! -f "$UV_CFG" ]; then
  echo "→ Creating uv config (default Python 3.14)"
  cat > "$UV_CFG" <<'EOF'
[python]
default = "3.14"
EOF
fi

# Pre-install Python 3.14 for uv
if ! uv python list | grep -q "3\.14"; then
  echo "→ Installing CPython 3.14 with uv"
  uv python install 3.14 || true
fi

# Optional: set Git noreply email for this machine (export GIT_EMAIL to override)
GIT_NAME_DEFAULT="buggerman"
GIT_EMAIL_DEFAULT="11626756+buggerman@users.noreply.github.com"
git config --global user.name  "${GIT_NAME:-$GIT_NAME_DEFAULT}"    || true
git config --global user.email "${GIT_EMAIL:-$GIT_EMAIL_DEFAULT}"  || true

echo "→ Done. Open a new shell or run: exec \$SHELL"
echo ""
echo "Next steps:"
echo "  1. Launch Ghostty (GUI apps installed via Homebrew cask)"
echo "  2. Font: JetBrainsMono Nerd Font should be available"
echo "  3. Open Neovim - NvChad will auto-install plugins on first run"
echo "  4. For Neovide: Run 'neovide' from terminal for GUI Neovim with cursor effects"
