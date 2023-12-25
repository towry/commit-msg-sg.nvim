local M = {
  Ghost_Text_Ns = 'sg.cody.gitcommit',
}

local ghost_text_ns = nil

local function is_vim_supported()
  if type(vim.uv.cwd) ~= 'function' or type(vim.system) ~= 'function' then
    return false
  end
  return true
end

local function thorws_if_vim_not_supported()
  if not is_vim_supported() then
    error("This plugin not working in your neovim version", vim.log.levels.ERROR)
  end
end

function M.throws_if_deps_is_missing()
  local ok, _ = pcall(require, 'sg.mark')
  if not ok then
    error("This plugin depends on sg.nvim", vim.log.levels.ERROR)
    return
  end
end

---@param opts {callback?: function,cmd?:table,cwd?:string}
---callback parameters: {error?: string, output?:string}
function M.fetch_git_diff_as_text(opts)
  thorws_if_vim_not_supported()

  opts = opts or {}
  local cmd = opts.cwd or {
    'git',
    'diff',
    '--staged',
    '--unified=0',
  }
  if type(cmd) ~= 'table' then error("cmd must be table of strings", vim.log.levels.ERROR) end

  local cwd = opts.cwd or vim.uv.cwd()
  local callback = opts.callback
  if not callback then return end

  local on_exit = vim.schedule_wrap(function(obj)
    if obj.code ~= 0 then
      return callback(obj.stderr or "failed to get git diff", nil)
    end
    return callback(nil, obj.stdout)
  end)

  vim.system(cmd, {
    text = true,
    cwd = opts.cwd,
  }, on_exit)
end

--- Update first line ghost text.
---@param text? string
function M.update_ghost_text(bufnr, text)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if not bufnr then
    if ghost_text_ns ~= nil then
      text = nil
    else
      error("bufnr is required", vim.log.levels.ERROR)
    end
  end
  if text == nil and ghost_text_ns ~= nil then
    vim.api.nvim_buf_clear_namespace(bufnr, ghost_text_ns, 0, -1);
    ghost_text_ns = nil
    return
  end

  if not ghost_text_ns then
    ghost_text_ns = vim.api.nvim_create_namespace(M.Ghost_Text_Ns)
  end

  vim.api.nvim_buf_set_extmark(bufnr, ghost_text_ns, 0, 0, {
    virt_text = { { text, 'Comment' } },
    virt_text_pos = 'eol',
    virt_text_hide = false,
  })
end
