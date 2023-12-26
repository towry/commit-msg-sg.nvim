local utils = require("commit-msg-sg.utils")

local id = 1

-- prototype of SimpleWritter
local SimpleWritter = {}

-- create instance of SimpleWritter
SimpleWritter.init = function(bufnr)
  utils.throws_if_deps_is_missing()
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if not bufnr then
    error("bufnr is required", vim.log.levels.ERROR)
  end

  local Mark = require("sg.mark")
  local mark = Mark.init({
    ns = bufnr,
    bufnr = bufnr,
    start_row = 0,
    start_col = 0,
    end_row = 1,
    end_col = 0,
  })
  id = id + 1
  return setmetatable({
    bufnr = bufnr,
    text = "",
    id = id,
    marker = mark,
  }, { __index = SimpleWritter })
end

function SimpleWritter:update(text)
  if self:invalid() then
    return
  end

  self.text = text or ""

  local lines = vim.split(text, "\n")
  -- iterate the lines, if vim.trim(line) is ```, ignore it
  local new_lines = {}
  for _, line in ipairs(lines) do
    if vim.trim(line) ~= "```" then
      table.insert(new_lines, line)
    end
  end
  vim.api.nvim_buf_set_lines(
    self.bufnr,
    self.marker:start_pos().row,
    self.marker:end_pos().row,
    false,
    new_lines
  )
end

function SimpleWritter:invalid()
  return self.id ~= id
end

function SimpleWritter:reset()
  if vim.fn.getline(1) == "" then
    return
  end
  local marker = self.marker
  local end_row = marker:end_pos().row - 1
  if end_row <= 0 then
    end_row = 1
  end
  vim.api.nvim_buf_set_lines(self.bufnr, marker:start_pos().row, end_row, false, {})
end

return SimpleWritter
