-- instalar plugins
vim.pack.add({
  { src = "https://github.com/williamboman/mason.nvim", opt = true },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim", opt = true },
  { src = "https://github.com/neovim/nvim-lspconfig", opt = true },
})

-- lazy load no BufReadPre (igual ao lazy.nvim)
vim.api.nvim_create_autocmd("BufReadPre", {
  once = true,
  callback = function()
    -- carregar plugins
    vim.cmd("packadd mason.nvim")
    vim.cmd("packadd mason-lspconfig.nvim")
    vim.cmd("packadd nvim-lspconfig")

    -- setup mason
    require("mason").setup()
    require("mason-lspconfig").setup()

    -- LSP config
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local on_attach = function(_, bufnr)
      local map = function(mode, keys, func, desc)
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
      end

      map("n", "gD", vim.lsp.buf.declaration, "Ir para declaração")
      map("n", "gd", vim.lsp.buf.definition, "Ir para definição")
      map("n", "K", vim.lsp.buf.hover, "Documentação")
      map("n", "gi", vim.lsp.buf.implementation, "Ir para implementação")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Renomear")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Ação de código")
      map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "Formatar")
    end

    -- configs LSP
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        typescript = {
          inlayHints = { includeInlayParameterNameHints = "all" },
        },
        javascript = {
          inlayHints = { includeInlayParameterNameHints = "all" },
        },
      },
      root_dir = function(bufnr, on_dir)
        local project_root = vim.fs.root(bufnr, {
          "package.json",
          ".git",
        })
        if project_root then
          return on_dir(project_root)
        end
        return on_dir(vim.fn.getcwd())
      end,
    })

    vim.lsp.config("bashls", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- filetypes
    vim.lsp.config("ts_ls", {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
    })

    vim.lsp.config("lua_ls", {
      filetypes = { "lua" },
    })

    vim.lsp.config("bashls", {
      filetypes = { "bash", "sh" },
    })

    vim.lsp.config("html", {
      filetypes = { "html" },
    })

    vim.lsp.config("cssls", {
      filetypes = { "css" },
    })
  end,
})