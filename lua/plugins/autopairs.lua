vim.pack.add({
  { src = "https://github.com/windwp/nvim-autopairs", opt = true }
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.cmd("packadd nvim-autopairs")
    require("nvim-autopairs").setup({})
  end,
})