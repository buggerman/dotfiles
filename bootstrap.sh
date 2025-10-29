#!/usr/bin/env bash
set -e

echo "→ Installing core tools via Homebrew"
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install zsh git uv fnm direnv eza bat ripgrep starship neovim

echo "→ Linking dotfiles"
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
mkdir -p ~/.config/starship
ln -sf ~/dotfiles/config/starship/starship.toml ~/.config/starship.toml

echo "→ Done! Launch a new shell."
