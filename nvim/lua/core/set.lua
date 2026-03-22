-- Cross-platform settings for Linux, macOS, and WSL

-- Detect OS
local sysname = "Linux"
if vim.uv and vim.uv.os_uname then
  sysname = vim.uv.os_uname().sysname or "Linux"
elseif vim.loop and vim.loop.os_uname then
  sysname = vim.loop.os_uname().sysname or "Linux"
end

local is_windows = sysname:match("Windows") or os.getenv("WSL_DISTRO_NAME")
local is_mac = sysname:match("Darwin")
local is_linux = sysname:match("Linux") and not is_windows

-- Basic settings
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autochdir = false
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

-- Cross-platform undodir
local home = os.getenv("HOME") or os.getenv("USERPROFILE") or vim.env.HOME or vim.env.USERPROFILE or ""
local undodir = home .. "/.vim/undodir"
-- Create directory if it doesn't exist
if home ~= "" then
  os.execute("mkdir -p " .. undodir)
end
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Cross-platform shell
if is_windows then
  vim.opt.shell = "powershell.exe"
elseif is_mac then
  vim.opt.shell = "zsh"
else
  vim.opt.shell = "bash"
end

-- Windows-specific cabbrev (only if on Windows)
if is_windows and home ~= "" then
  vim.cmd([[
    cabbrev nvim cd ~/.config/nvim
  ]])
end
