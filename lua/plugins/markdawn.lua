vim.pack.add({
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim", opt = true }
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.cmd("packadd render-markdown")
    require("render-markdown").setup({})
  end,
})
