return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()

    vim.lsp.config("ts_ls", {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
    })

    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash" }
    })

    vim.lsp.config("lua_ls", {
      filetypes = { "lua" }
    })

    vim.lsp.config("bash_ls", {
      filetypes = { "bash", "sh" }
    })
  end
}
