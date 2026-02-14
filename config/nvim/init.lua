vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
-- Only load Neovide settings if we are actually in Neovide
if vim.g.neovide then
    require('neovide_settings')
end
-- 1. Create the transparency function
local function make_transparent()
    local hl_groups = {
        "Normal", "NormalFloat", "NormalNC", "LineNr", "Folded",
        "NonText", "SpecialKey", "VertSplit", "WinSeparator",
        "SignColumn", "EndOfBuffer", "NvimTreeNormal", "NvimTreeNormalNC"
    }
    for _, group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
end

-- 2. Run it immediately
make_transparent()

-- 3. Run it again whenever the colorscheme changes (e.g. via NvChad theme switcher)
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        make_transparent()
    end,
})
