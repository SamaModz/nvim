vim.pack.add({
  { src = "https://github.com/catgoose/nvim-colorizer.lua", opt = true }
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.cmd("packadd nvim-colorizer.lua")

    require("colorizer").setup({
      options = {
        display = {
          mode = "foreground",
        },
      },
    })
  end,
})