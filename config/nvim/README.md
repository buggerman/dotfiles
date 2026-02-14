─────┬──────────────────────────────────────────────────────────────────────────
     │ STDIN
─────┼──────────────────────────────────────────────────────────────────────────
   1 │ # Neovim Configuration
   2 │ 
   3 │ Custom NvChad configuration with transparency support and Neovide integration.
   4 │ 
   5 │ ## Features
   6 │ 
   7 │ - **NvChad v2.5**: Feature-rich Neovim distribution with lazy.nvim plugin manager
   8 │ - **Transparency**: Terminal background transparency for modern terminal emulators (Ghostty, WezTerm, Kitty, etc.)
   9 │ - **Neovide Support**: Conditional loading of Neovide-specific settings with animated cursor effects
  10 │ - **Theme**: OneDark color scheme
  11 │ - **Custom Keybindings**: Including `jk` for escape and `;` for command mode
  12 │ 
  13 │ ## Files
  14 │ 
  15 │ ### `init.lua`
  16 │ Main configuration entry point that:
  17 │ - Sets up lazy.nvim plugin manager
  18 │ - Loads NvChad with custom configurations
  19 │ - Implements transparency function that removes background colors from various highlight groups
  20 │ - Conditionally loads Neovide settings when running in Neovide
  21 │ - Applies transparency on colorscheme changes
  22 │ 
  23 │ ### `lua/neovide_settings.lua`
  24 │ Neovide-specific configuration (loaded only when `vim.g.neovide` is true):
  25 │ - **Cursor Effects**: Railgun cursor animation with custom trail and particle settings
  26 │ - **Window Appearance**: 85% opacity with window blur effect
  27 │ - **macOS Clipboard**: Native Cmd+C, Cmd+V, Cmd+X shortcuts that work properly
  28 │ 
  29 │ ### `lua/chadrc.lua`
  30 │ NvChad theme and UI configuration:
  31 │ - Sets theme to "onedark"
  32 │ - Configuration structure follows [nvconfig.lua](https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua)
  33 │ 
  34 │ ### `lua/options.lua`
  35 │ Vim options (currently uses NvChad defaults)
  36 │ 
  37 │ ### `lua/mappings.lua`
  38 │ Custom keybindings:
  39 │ - `;` → Enter command mode (`:`)
  40 │ - `jk` in insert mode → Exit to normal mode (`<ESC>`)
  41 │ 
  42 │ ### `lua/autocmds.lua`
  43 │ Autocommands (currently uses NvChad defaults)
  44 │ 
  45 │ ## Usage
  46 │ 
  47 │ These files are designed to be symlinked by the [repeatable-environment](https://github.com/buggerman/repeatable-environment) Ansible playbook:
  48 │ 
  49 │ 1. Clone this dotfiles repo to `~/dotfiles`
  50 │ 2. Run the Ansible playbook which will:
  51 │    - Clone NvChad starter to `~/.config/nvim`
  52 │    - Symlink these config files to overlay custom settings
  53 │ 3. Launch Neovim - plugins will install automatically on first run
  54 │ 
  55 │ ## Customization
  56 │ 
  57 │ ### Change Theme
  58 │ Edit `lua/chadrc.lua`:
  59 │ ```lua
  60 │ M.base46 = {
  61 │     theme = "onedark",  -- Change to any NvChad theme
  62 │ }
  63 │ ```
  64 │ 
  65 │ ### Disable Transparency
  66 │ Comment out or remove the transparency function in `init.lua`:
  67 │ ```lua
  68 │ -- local function make_transparent()
  69 │ --     ...
  70 │ -- end
  71 │ -- make_transparent()
  72 │ ```
  73 │ 
  74 │ ### Adjust Neovide Opacity
  75 │ Edit `lua/neovide_settings.lua`:
  76 │ ```lua
  77 │ vim.g.neovide_opacity = 0.85  -- Change value (0.0 to 1.0)
  78 │ ```
  79 │ 
  80 │ ### Add Custom Keybindings
  81 │ Edit `lua/mappings.lua`:
  82 │ ```lua
  83 │ local map = vim.keymap.set
  84 │ map("n", "<your-key>", "<your-command>", { desc = "Description" })
  85 │ ```
  86 │ 
  87 │ ## Requirements
  88 │ 
  89 │ - Neovim >= 0.9.0
  90 │ - Git (for lazy.nvim plugin manager)
  91 │ - NvChad starter (installed by Ansible playbook)
  92 │ - Optional: Neovide for GUI features
  93 │ - Optional: Modern terminal with transparency support (Ghostty, WezTerm, Kitty)
  94 │ 
  95 │ ## Terminal-Specific Notes
  96 │ 
  97 │ ### Ghostty
  98 │ Transparency works out of the box when `background-opacity` is set in Ghostty config.
  99 │ 
 100 │ ### iTerm2 / Terminal.app
 101 │ May need to adjust transparency settings in terminal preferences.
 102 │ 
 103 │ ### Neovide
 104 │ Transparency is handled by `neovide_opacity` setting instead of terminal transparency.
 105 │ 
 106 │ ## Plugin Management
 107 │ 
 108 │ Plugins are managed by lazy.nvim through NvChad. To add custom plugins, create files in `~/.config/nvim/lua/plugins/` (not tracked in dotfiles).
 109 │ 
 110 │ ## Troubleshooting
 111 │ 
 112 │ ### Transparency not working
 113 │ - Ensure your terminal supports transparency
 114 │ - Check terminal's transparency/opacity settings
 115 │ - Some themes may override transparency - try changing theme
 116 │ 
 117 │ ### Neovide shortcuts not working
 118 │ - Shortcuts only load when running in Neovide (not terminal Neovim)
 119 │ - On non-macOS systems, Cmd key mappings won't work (use Ctrl instead)
 120 │ 
 121 │ ### Plugins not installing
 122 │ ```bash
 123 │ # Open Neovim and wait for lazy.nvim
 124 │ nvim
 125 │ 
 126 │ # Or manually trigger sync
 127 │ nvim --headless "+Lazy! sync" +qa
 128 │ ```
─────┴──────────────────────────────────────────────────────────────────────────
