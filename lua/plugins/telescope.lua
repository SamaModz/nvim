vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim", opt = true },
  { src = "https://github.com/nvim-telescope/telescope.nvim", opt = true },
})

vim.api.nvim_create_autocmd("CmdUndefined", {
  pattern = "Telescope",
  callback = function()
    vim.cmd("packadd plenary.nvim")
    vim.cmd("packadd telescope.nvim")
    require("telescope").setup({})
  end,
})