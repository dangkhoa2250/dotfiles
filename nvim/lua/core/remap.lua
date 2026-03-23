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


vim.api.nvim_set_keymap('n', ',cc', ':lua _G.comment_line("n")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',cc', ':<C-u>lua _G.comment_line("v")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',cu', ':lua _G.uncomment_line("n")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', ',cu', ':<C-u>lua _G.uncomment_line("v")<CR>', { noremap = true, silent = true })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/core/plugins/init.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("source " .. vim.env.MYVIMRC)
end)

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


