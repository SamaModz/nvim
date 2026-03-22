return {
  "catgoose/nvim-colorizer.lua",
  event = "VimEnter",
  config = function()
    require("colorizer").setup({
      options = {
        display = {
          mode = "foreground", -- Altera o modo de exibição para foreground
        },
      },
    })
  end
}
