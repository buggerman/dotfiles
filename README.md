# 🧰 buggerman’s dotfiles

A minimal, reproducible macOS environment powered by **Zsh**, **uv**, **fnm**, and **direnv** — with smart per-terminal behavior:
- **iTerm2** → Starship prompt, Nerd Font icons, pretty `bat`, `eza --icons`
- **Terminal.app** → vanilla Monaco, no icons, simple defaults

---

## ✨ Features
 
### 💻 Shell & UX
- macOS **/bin/zsh** (no Homebrew zsh) with a clean, fast config
- **Conditional config by terminal**
  - iTerm2 gets all the goodies
  - Terminal.app stays classic and icon-free
- **Oh-My-Zsh** (eastwood theme) only in iTerm2
- Smart history (`SHARE_HISTORY`, large size), safe file ops (`NO_CLOBBER`)

### 🧠 Runtimes & Tools
| Tool | Purpose | Notes |
|------|----------|-------|
| [`uv`](https://github.com/astral-sh/uv) | Python versions & venvs | Default Python **3.14** |
| [`fnm`](https://github.com/Schniz/fnm) | Fast Node version manager | `--use-on-cd` + Corepack |
| [`direnv`](https://direnv.net) | Auto-load per-project env | Works with uv `.venv` |
| [`eza`](https://github.com/eza-community/eza) | Better `ls` | Icons **only** in iTerm2 |
| [`bat`](https://github.com/sharkdp/bat) | Better `cat` | Pretty in iTerm2, plain in Terminal |
| [`rg`](https://github.com/BurntSushi/ripgrep) | Fast search | Aliased to `grep` |
| [`starship`](https://starship.rs) | Prompt | iTerm2 only |
| [`neovim`](https://neovim.io) | Editor | `$EDITOR`/`$VISUAL` = `nvim` |

---

## 📁 Layout

```
dotfiles/
├─ bootstrap.sh
├─ zsh/
│  └─ .zshrc
├─ config/
│  ├─ nvim/                 # Neovim/NvChad configuration
│  │  ├─ README.md          # Detailed nvim config docs
│  │  ├─ init.lua           # Main config with transparency
│  │  └─ lua/
│  │     ├─ neovide_settings.lua  # Neovide-specific settings
│  │     ├─ chadrc.lua      # NvChad theme config
│  │     ├─ options.lua     # Vim options
│  │     ├─ mappings.lua    # Keybindings
│  │     └─ autocmds.lua    # Autocommands
│  ├─ ghostty/
│  │  └─ config             # Ghostty terminal config
│  ├─ neovide/
│  │  └─ config.toml        # Neovide GUI config
│  ├─ starship/
│  │  └─ starship.toml
│  └─ uv/
│     └─ config.toml        # optional; generated if missing
└─ .ripgreprc               # optional
```

> The `.zshrc` uses `$TERM_PROGRAM` to split behavior:
> - `iTerm.app` → OMZ + Starship + icons, etc.
> - `Apple_Terminal` → vanilla

> **Neovim Configuration**: See `config/nvim/README.md` for detailed documentation on NvChad setup, transparency, Neovide integration, and customization options.

---

## 🚀 Quick Install (New Mac)

```bash
# 1) Clone
git clone https://github.com/buggerman/dotfiles.git ~/dotfiles

# 2) Bootstrap
bash ~/dotfiles/bootstrap.sh

# 3) Reload
exec $SHELL
```

iTerm2 tip: Preferences → Profiles → Text → Font → select "Monaspace Neon Nerd Font" (installed by bootstrap).
Terminal.app: keep Monaco to stay icon-free.

> **Note**: Neovim configuration is managed by the [repeatable-environment](https://github.com/buggerman/repeatable-environment) Ansible playbook, which clones NvChad and symlinks these config files. For full environment setup including Neovim, Ghostty, Neovide, and more, use the Ansible playbook instead.

⸻

🧠 Daily Workflow

🐍 Python (uv)

cd myproj
uv venv --python 3.14
echo 'source .venv/bin/activate' > .envrc && direnv allow
uv add requests pytest
uv run pytest

🪄 Node (fnm)

fnm install 22
# .node-version → "22" in project
# auto-switches on cd (thanks to --use-on-cd)


⸻

🔁 Updating

cd ~/dotfiles
git pull --rebase
bash bootstrap.sh   # safe to re-run


⸻

🛠 Troubleshooting

Issue	Cause	Fix
Icons look weird in iTerm2	Missing Nerd Font	Set Monaspace Neon Nerd Font
Icons showing in Terminal.app	Unwanted?	.zshrc disables them automatically
py: shows with no version	No active Python env	Activate venv or fix Starship config
> won’t overwrite files	NO_CLOBBER set	Use `>


⸻

🔧 bootstrap.sh

The bootstrap script installs Homebrew, core CLI tools, Nerd Font, and symlinks configs:

#!/usr/bin/env bash
set -euo pipefail

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

brew update
brew install git uv fnm direnv eza bat ripgrep starship neovim
brew tap homebrew/cask-fonts
brew install --cask font-monaspace-neon-nerd-font || true

mkdir -p "$HOME/.config/starship" "$HOME/.config/uv"

link() {
  local src="$1"
  local dst="$2"
  [ -e "$src" ] && ln -sf "$src" "$dst"
}

link "$DOTFILES_DIR/zsh/.zshrc"                      "$HOME/.zshrc"
link "$DOTFILES_DIR/config/starship/starship.toml"   "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/.ripgreprc"                      "$HOME/.ripgreprc"

UV_CFG="$HOME/.config/uv/config.toml"
if [ ! -f "$UV_CFG" ]; then
  echo "[python]" > "$UV_CFG"
  echo 'default = "3.14"' >> "$UV_CFG"
fi

if ! uv python list | grep -q "3\.14"; then
  uv python install 3.14 || true
fi

git config --global user.name  "buggerman"
git config --global user.email "11626756+buggerman@users.noreply.github.com"

echo "→ Done. Open a new shell or run: exec \$SHELL"
echo "Tip: In iTerm2, set font to 'Monaspace Neon Nerd Font'; Terminal.app stays Monaco."


⸻

🧑‍💻 Author

buggerman
11626756+buggerman@users.noreply.github.com￼
💻 GitHub: buggerman￼

⸻

🪄 License

MIT￼

Minimal, reproducible, and elegant — because your shell should feel like home.

---
