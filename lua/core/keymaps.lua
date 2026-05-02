vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>e', "<cmd>Explore<CR>", { desc = 'Explorador de arquivos', silent = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Salvar arquivo' })
vim.keymap.set('n', '<leader>q', '<cmd>close<R>', { desc = 'Fechar buffer' })
vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { desc = 'Fechar tudo' })
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Limpar busca' })
vim.keymap.set('n', '<leader>t', '<cmd>terminal<CR>', { desc = 'Abrir terminal' })
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>', { desc = 'Sair do terminal' })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'Próximo buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Buffer anterior' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Fechar buffer' })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<CR>', { desc = 'Próxima tab' })
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', { desc = 'Tab anterior' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabnew<CR>', { desc = 'Nova tab' })

vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'd', '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'x', '"_x', { noremap = true, silent = true })


vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>ThemePicker<cr>", { silent = true })
