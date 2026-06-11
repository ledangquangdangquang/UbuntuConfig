-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- catppuccin theme
vim.schedule(function()
  vim.cmd.colorscheme("catppuccin")
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end)
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.spell = false
vim.opt.wrap = true
opts = { dashboard = { enabled = false } }
