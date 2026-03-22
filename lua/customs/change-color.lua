local M = {}

local original_theme = nil
local win_id = nil
local buf_id = nil
local augroup_id = nil

local theme_file = vim.fn.stdpath("config") .. "/.last_theme"

local function load_saved_theme()
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if lines[1] and lines[1] ~= "" then
      pcall(vim.cmd, "colorscheme " .. lines[1])
    end
  end
end

load_saved_theme()

local function get_themes()
  local themes = {}

  for _, path in ipairs(vim.api.nvim_get_runtime_file("colors/*.vim", true)) do
    table.insert(themes, vim.fn.fnamemodify(path, ":t:r"))
  end

  for _, path in ipairs(vim.api.nvim_get_runtime_file("colors/*.lua", true)) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    if not vim.tbl_contains(themes, name) then
      table.insert(themes, name)
    end
  end

  table.sort(themes)
  return themes
end

local function apply_theme(theme)
  if not theme or theme == "" then
    return
  end

  local ok = pcall(vim.cmd, "colorscheme " .. theme)

  if ok then
    local config = vim.fn.stdpath("config") .. "/init.lua"
    if vim.fn.filereadable(config) == 1 then
      pcall(vim.cmd, "silent source " .. config)
    end
  end
end

local function save_theme(theme)
  if theme then
    vim.fn.writefile({ theme }, theme_file)
  end
end

local function close_picker(revert)
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end

  if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    vim.api.nvim_buf_delete(buf_id, { force = true })
  end

  if augroup_id then
    pcall(vim.api.nvim_del_augroup_by_id, augroup_id)
  end

  if revert then
    apply_theme(original_theme)
  end

  win_id = nil
  buf_id = nil
  augroup_id = nil
  original_theme = nil
end

local function setup_highlights()
  vim.api.nvim_set_hl(0, "ThemePickerTitle", {
    link = "Title"
  })

  vim.api.nvim_set_hl(0, "ThemePickerBorder", {
    link = "FloatBorder"
  })

  vim.api.nvim_set_hl(0, "ThemePickerCursorLine", {
    link = "Visual"
  })
end

function M.open_theme_picker()

  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_set_current_win(win_id)
    return
  end

  setup_highlights()

  original_theme = vim.g.colors_name
  local themes = get_themes()

  buf_id = vim.api.nvim_create_buf(false, true)

  vim.bo[buf_id].buftype = "nofile"
  vim.bo[buf_id].bufhidden = "wipe"
  vim.bo[buf_id].swapfile = false
  vim.bo[buf_id].modifiable = true

  local title = "  Theme Picker  "
  local lines = { title, "" }

  for _, theme in ipairs(themes) do
    if theme == original_theme then
      table.insert(lines, "    " .. theme)
    else
      table.insert(lines, "     " .. theme)
    end
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  vim.bo[buf_id].modifiable = false

  local height = math.min(#lines, math.floor(vim.o.lines * 0.8))
  local width = 40
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    border = "rounded",
    style = "minimal",
  })

  vim.wo[win_id].cursorline = true
  vim.wo[win_id].number = false
  vim.wo[win_id].relativenumber = false
  vim.wo[win_id].wrap = false
  vim.wo[win_id].winblend = 10
  vim.wo[win_id].cursorlineopt = "line"

  vim.api.nvim_win_set_hl_ns(win_id, 0)
  vim.api.nvim_win_set_option(win_id, "winhighlight",
  "FloatBorder:ThemePickerBorder,CursorLine:ThemePickerCursorLine")

  augroup_id =
  vim.api.nvim_create_augroup("ThemePickerGroup", { clear = true })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup_id,
    buffer = buf_id,
    callback = function()
      local line = vim.api.nvim_win_get_cursor(win_id)[1]
      if line > 2 then
        local theme = themes[line - 2]
        apply_theme(theme)
      end
    end,
  })

  local function map(key, fn)
    vim.keymap.set("n", key, fn, { buffer = buf_id, silent = true })
  end

  map("q", function() close_picker(true) end)
  map("<esc>", function() close_picker(true) end)

  map("<cr>", function()
    local line = vim.api.nvim_win_get_cursor(win_id)[1]
    if line > 2 then
      local selected = themes[line - 2]
      save_theme(selected)
      close_picker(false)
    end
  end)

  vim.api.nvim_win_set_cursor(win_id, { 3, 0 })
end

vim.api.nvim_create_user_command("ThemePicker", function()
  M.open_theme_picker()
end, {})

return M
