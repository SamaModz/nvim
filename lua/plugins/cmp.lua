return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
  },
  config = function()
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
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
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
      function(entry1, entry2)
        local kind1 = entry1:get_kind()
        local kind2 = entry2:get_kind()

        local kind_priority = {
          [types.lsp.CompletionItemKind.Field] = 1,
          [types.lsp.CompletionItemKind.Method] = 2,
          [types.lsp.CompletionItemKind.Variable] = 3,
          [types.lsp.CompletionItemKind.Function] = 4,
        }

        local p1 = kind_priority[kind1] or 99
        local p2 = kind_priority[kind2] or 99

        if p1 ~= p2 then
          return p1 < p2
        end
      end,

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
    { name = "buffer" },
    { name = "path" },
  },
   })
  end,
}
