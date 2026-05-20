local function load_modules_from(dir)
  local config_path = vim.fn.stdpath("config") .. "/lua/" .. dir
  local scan = vim.loop.fs_scandir(config_path)
  if not scan then return end
  while true do
    local name, typ = vim.loop.fs_scandir_next(scan)
    if not name then break end
    if typ == "file" and name:sub(-4) == ".lua" then
      local module = dir .. "." .. name:gsub("%.lua$", "")
      local ok, err = pcall(require, module)
      if not ok then
        vim.notify("Error loading module: " .. module .. "\n" .. err, vim.log.levels.ERROR)
      end
    end
  end
end

load_modules_from("core")
load_modules_from("plugins")
load_modules_from("customs")


require("vim._core.ui2").enable({})
