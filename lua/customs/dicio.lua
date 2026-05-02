
local M = {}

local function show_float_window(content)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))

  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_height = math.min(math.floor(height * 0.8), #vim.split(content, '\n') + 2)
  local win_width = math.min(math.floor(width * 0.8), 80)

  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = win_width,
    height = win_height,
    border = "single",
    focusable = true,
    style = "minimal",
  })

  vim.api.nvim_set_current_win(win)
  -- Map 'q' to close the window
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
end

function M.define_visual_word()
  -- Get the visual selection
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  
  if #lines == 0 then
    show_float_window("Nenhuma palavra selecionada.")
    return
  end

  lines[1] = string.sub(lines[1], s_start[3])
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  local word = table.concat(lines, '\n')

  if word and word ~= "" then
    -- Get the path to dicio.mjs relative to this lua file
    local info = debug.getinfo(1, "S")
    local script_dir = info.source:sub(2):match("(.*/)")
    local script_path = script_dir .. "dicio.mjs"

    -- Execute the Node.js script
    local command = {"node", script_path, word}
    local output = vim.fn.system(command)

    if vim.v.shell_error == 0 then
      show_float_window(output)
    else
      show_float_window("Erro ao executar o script Node.js: " .. output)
    end
  else
    show_float_window("Nenhuma palavra selecionada no modo Visual.")
  end
end

-- Setup keybinding for visual mode
vim.api.nvim_set_keymap("x", "<leader>d", ":<C-u>lua require(\'dicio\').define_visual_word()<CR>", {noremap = true, silent = true})

return M
