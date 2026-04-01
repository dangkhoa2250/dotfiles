-- Key mappings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", ";", ":")

-- Clipboard with Ctrl
vim.keymap.set('n', '<C-y>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('n', '<C-p>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('v', '<C-y>', '"+y', { desc = 'Copy selection to clipboard' })
vim.keymap.set('i', '<C-p>', '<C-o>"+p', { desc = 'Paste from clipboard' })

vim.api.nvim_set_keymap('n', ',cc', ':lua _G.comment_line("n")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',cc', ':<C-u>lua _G.comment_line("v")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',cu', ':lua _G.uncomment_line("n")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',cu', ':<C-u>lua _G.uncomment_line("v")<CR>', { noremap = true, silent = true })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- LSP Rename (short)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/core/plugins/init.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("source " .. vim.env.MYVIMRC)
end)

-- Obsidian Workflows
vim.keymap.set("n", "<leader>on", ":ObsidianTemplate<CR>", { desc = "Insert Obsidian Template" })

vim.keymap.set("n", "<leader>ok", function()
  local current_file = vim.fn.expand("%:p")
  local vault_path = "~/Onedrive/Obsidian/Obsidian Vault"
  local zettelkasten_dir = vault_path .. "/notes/"

  vim.fn.system("mv '" .. current_file .. "' '" .. zettelkasten_dir .. "'")
  vim.cmd("bd")
  print("Da luu vao notes: " .. vim.fn.expand("%:t"))
end, { desc = "Keep Note (Move to notes)" })

vim.keymap.set("n", "<leader>od", function()
  local current_file = vim.fn.expand("%:p")
  vim.fn.system("rm '" .. current_file .. "'")
  vim.cmd("bd")
  print("Da xoa note: " .. vim.fn.expand("%:t"))
end, { desc = "Delete Note" })

-- -- Nvim-tree mapping
-- vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
-- Define comment leaders based on file types
_G.comment_leaders = {
    c = '// ', cpp = '// ', java = '// ', scala = '// ',
    sh = '# ', ruby = '# ', python = '# ', ps1 = '# ',
    conf = '# ', fstab = '# ',
    tex = '% ',
    mail = '> ',
    lua = "-- ",
    vim = '" ',
}

-- Autocommand group for setting comment leaders
vim.api.nvim_create_augroup('commenting_blocks_of_code', { clear = true })
for filetype, leader in pairs(comment_leaders) do
    vim.api.nvim_create_autocmd('FileType', {
        group = 'commenting_blocks_of_code',
        pattern = filetype,
        callback = function() vim.b.comment_leader = leader end
    })
end

-- Global comment function
function _G.comment_line(mode)
    local leader = vim.api.nvim_buf_get_var(0, 'comment_leader')
    if mode == 'n' then
        vim.cmd('silent s/^/' .. vim.fn.escape(leader, '\\/') .. '/')
    else  -- Visual mode
        vim.cmd('silent \'<,\'>s/^/' .. vim.fn.escape(leader, '\\/') .. '/')
    end
    vim.cmd('nohlsearch')
end

-- Global uncomment function
function _G.uncomment_line(mode)
    local leader = vim.api.nvim_buf_get_var(0, 'comment_leader')
    if mode == 'n' then
        vim.cmd('silent s/^\\V' .. vim.fn.escape(leader, '\\/') .. '//e')
    else  -- Visual mode
        vim.cmd('silent \'<,\'>s/^\\V' .. vim.fn.escape(leader, '\\/') .. '//e')
    end
    vim.cmd('nohlsearch')
end


