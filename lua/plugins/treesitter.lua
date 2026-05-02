vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", opt = true }
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.cmd("packadd nvim-treesitter")

    vim.defer_fn(function()
      require("nvim-treesitter").setup({
        highlight = { enable = true },
        indent = { enable = true },
        install_dir = vim.fn.stdpath("data")
      })
      require("nvim-treesitter").install({
        "javascript",
        "bash",
        "css",
        "lua"
      })
    end, 10)
  end,
})