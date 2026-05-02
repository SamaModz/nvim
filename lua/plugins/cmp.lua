-- instalar plugins
vim.pack.add({
  { src = "https://github.com/hrsh7th/nvim-cmp", opt = true },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp", opt = true },
  { src = "https://github.com/hrsh7th/cmp-buffer", opt = true },
  { src = "https://github.com/hrsh7th/cmp-path", opt = true },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip", opt = true },
  { src = "https://github.com/L3MON4D3/LuaSnip", opt = true },
})

-- lazy load no InsertEnter (igual ao event do lazy.nvim)
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    -- carregar plugins manualmente
    vim.cmd("packadd nvim-cmp")
    vim.cmd("packadd cmp-nvim-lsp")
    vim.cmd("packadd cmp-buffer")
    vim.cmd("packadd cmp-path")
    vim.cmd("packadd cmp_luasnip")
    vim.cmd("packadd LuaSnip")

    -- config original (praticamente igual)
    local cmp = require("cmp")
    local types = require("cmp.types")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            buffer   = "[BUF]",
            path     = "[PATH]",
          })[entry.source.name]

          return vim_item
        end,
      },

      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end,
})