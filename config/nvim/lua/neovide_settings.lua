-- ~/.config/nvim/lua/neovide_settings.lua

-- 1. THE RAILGUN
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_animation_length = 0.02
vim.g.neovide_cursor_trail_size = 1.0
vim.g.neovide_cursor_vfx_particle_density = 8.0

-- 2. THE VISUALS
vim.g.neovide_opacity = 0.85
vim.g.neovide_window_blurred = true

-- 3. THE KEYBOARD (Cmd+V)
-- Using <D-v> is safe for your Swedish layout

-- 3.1. PASTE: Cmd + V
-- Normal/Visual mode: Paste system clipboard after cursor
vim.keymap.set({'n', 'v'}, '<D-v>', '"+p', { noremap = true, silent = true })
-- Insert mode: Insert system clipboard at cursor position
vim.keymap.set('i', '<D-v>', '<C-r>+', { noremap = true, silent = true })

-- 3.2. COPY: Cmd + C
-- Visual mode: Yank selection to system clipboard
vim.keymap.set('v', '<D-c>', '"+y', { noremap = true, silent = true })

-- 3.3. CUT: Cmd + X
-- Visual mode: Delete selection and send to system clipboard
vim.keymap.set('v', '<D-x>', '"+d', { noremap = true, silent = true })

-- 3.4. INSERT MODE FIX: Cmd + C / Cmd + X
-- Allow copying/cutting in Insert mode if you have text selected
vim.keymap.set('i', '<D-c>', '<Esc>"+ygi', { noremap = true, silent = true })
vim.keymap.set('i', '<D-x>', '<Esc>"+dgi', { noremap = true, silent = true })
