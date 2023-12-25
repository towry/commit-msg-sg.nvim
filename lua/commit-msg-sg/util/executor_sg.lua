local utils = require('lua.commit-msg-sg.utils')

local M = {}

local clients = {}

--- @param snippet string
--- @param callback function
function M.execute(bufnr, snippet, callback)
  local rpc = require('sg.cody.rpc')
  local client = clients[bufnr]
  if not client then
    error("setup not called", vim.log.levels.ERROR)
  end
  rpc.execute.code_question(snippet, function(res)
    if not res then
      return
    end
    local text = res.text .. '\n'
    callback(nil, text)
  end)
end

function M.setup(bufnr, config)
  utils.throws_if_deps_is_missing()

  require('sg.cody.rpc').start({
    force = false,
  }, function(client_or_nil)
    if client_or_nil == nil then
      vim.notify('cody client not started successfully');
      return
    end

    clients[bufnr] = client_or_nil
    if config.on_attach then
      config.on_attach(client_or_nil, bufnr)
    end
  end)
end

return M
