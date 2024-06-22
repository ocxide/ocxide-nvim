vim.opt.nu = true
vim.opt.relativenumber = true

-- Tab config
vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.wrap = false

-- clipboard
vim.opt.clipboard = ""

-- Clear search highlight
vim.keymap.set("n", "<ESC>", ":noh<CR>", { silent = true })
