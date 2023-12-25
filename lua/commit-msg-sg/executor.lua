local M = {}

local executor = nil

function M.setup(bufnr, config)
  local executor_name = config.executor
  if executor_name ~= 'sg' then
    error("executor must be 'sg', for now.", vim.log.levels.ERROR)
  end

  local ok, executor_ = pcall(require, 'commit-msg-sg.utils.executor_' .. executor_name)
  if not ok then error("executor not found", vim.log.levels.ERROR) end
  executor = executor_
  executor.setup(bufnr, config)
end

function M.execute(bufnr, snippet, callback)
  if not executor then
    error("setup not called", vim.log.levels.ERROR)
  end
  executor.execute(bufnr, snippet, callback)
end

return M
