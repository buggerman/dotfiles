#### ─────────────────────────── BASICS ───────────────────────────
# Homebrew first (Apple Silicon)
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:$PATH"

# User-level bin paths (uv, uvx, scripts)
export PATH="$HOME/.local/bin:$PATH"

# Preferred editor
export EDITOR="nvim"
export VISUAL="nvim"

#### ─────────────────────────── PER-TERMINAL BEHAVIOR ───────────────────────────
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  #### iTerm2: fancy setup (icons, starship, OMZ, aliases)

  # Oh My Zsh (eastwood etc.)
  [ -f "$HOME/.zshrc.omz" ] && source "$HOME/.zshrc.omz"

  # Node (fnm) with Corepack and auto-use on cd
  command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --corepack-enabled)"

  # direnv auto-envs
  command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

  # Pretty ls (eza with icons)
  command -v eza >/dev/null 2>&1 && alias ls='eza --group-directories-first --icons'

  # grep → ripgrep
  command -v rg  >/dev/null 2>&1 && alias grep='rg'

  # bat with nice decorations
  if command -v bat >/dev/null 2>&1; then
    export BAT_THEME="Dracula"
    alias cat='bat --paging=never --decorations=always --style=header,grid,numbers'
  fi

  # Starship prompt
  command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

else
  #### Terminal.app: vanilla (Monaco, stock tools, default prompt)

  # DO NOT load OMZ, Starship, icons, or overrides here.
  # Ensure no leftover aliases leak in if a subshell is spawned.
  unalias ls   2>/dev/null || true
  unalias cat  2>/dev/null || true
  unalias grep 2>/dev/null || true
  unset BAT_THEME

  # Keep direnv off for pure vanilla; uncomment if you still want auto-venv:
  # command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
fi

#### ─────────────────────────── QUALITY OF LIFE (safe everywhere) ───────────────────────────
# History & usability
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY INC_APPEND_HISTORY_TIME
setopt AUTO_CD EXTENDED_GLOB INTERACTIVE_COMMENTS NO_CLOBBER

# Simple, universal aliases (non-invasive)
alias ll='ls -lah'
alias gs='git status -sb'
alias gp='git pull --rebase --autostash && git push'

# Less pager settings that work with bat/rg color (harmless if unused)
export LESS='-RFX'

# (Optional) uv: if you want shell `python` to be uv’s 3.14 everywhere, uncomment:
# export PATH="$HOME/.local/share/uv/python/3.14.x/bin:$PATH"
