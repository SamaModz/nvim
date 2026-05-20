-- Configuração completa do folke/noice.nvim com vim.pack.add()

-- É altamente recomendado usar o Neovim nightly para o noice.nvim, pois ele utiliza a nova API experimental vim.ui_attach.
-- As dependências são instaladas e carregadas automaticamente pelo vim.pack.add().

-- Adiciona as dependências do noice.nvim
vim.pack.add('https://github.com/MunifTanjim/nui.nvim')
vim.pack.add('https://github.com/rcarriga/nvim-notify')

-- Adiciona o plugin noice.nvim
vim.pack.add('https://github.com/folke/noice.nvim')

-- Configuração do noice.nvim
-- O setup deve ser chamado após o plugin ser adicionado e carregado.
-- Para uma configuração mais avançada, consulte a documentação oficial do noice.nvim.
require('noice').setup({
  -- Exemplo de configuração básica:
  cmdline = {
    view = 'cmdline_popup',
  },
  messages = {
    view = 'popup',
  },
  popupmenu = {
    view = 'popup',
    size = {
      height = 10,
      width = 60,
    },
  },
  presets = {
    bottom_search = true, -- use a barra de comando na parte inferior para pesquisa
    command_palette = true, -- mostra a paleta de comandos
    long_message_to_split = true, -- mensagens longas em um split
    inc_rename = false, -- desabilita a renomeação incremental
    lsp_doc_border = false, -- desabilita borda para docs do LSP
  },
  -- Você pode adicionar mais opções de configuração aqui conforme sua preferência.
})

-- Opcional: Mapeamentos de teclas para interagir com o Noice
-- vim.keymap.set('n', '<leader>n', function() require('noice').cmd('last') end, { desc = 'Noice: Show last message' })
-- vim.keymap.set('n', '<leader>N', function() require('noice').cmd('all') end, { desc = 'Noice: Show all messages' })
