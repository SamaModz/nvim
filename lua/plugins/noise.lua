return {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      lsp_progress = {
        enabled = true,
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = "60%",
            height = "auto",
          },
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
      },
    })
  end
}
