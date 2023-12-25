local M = {}
local config = require('commit-msg-sg.config')
local utils = require('commit-msg-sg.utils')

local writters = {}

local prompt_str = [[
You are a git expert and experienced programmer that are here to help me write a git commit message in a git repo.\n
1. Generate concise and accurate git commit message based on the git diff that provided later with focus on the changed lines that start with "+","-".\n
2. Do not add additional information about the response, like how the generated content is better and follow the rules/standards.\n
4. The generated git commit message follow the Conventional commits standard.\n
6. Avoid duplicating the diff content.\n
The diff output:\n
```diff\n%s```
]]

local function on_attach(client, bufnr, opts)
  if opts.auto_setup_command then
    vim.api.nvim_buf_create_user_command(bufnr, 'WriteGitCommitMessage', M.write, {
      desc = 'Write git commit with AI',
    })
  end
end

function M.setup(opts)
  opts = opts or {}
  local on_attach_ = opts.on_attach
  opts.on_attach = function(client, bufnr)
    on_attach(client, bufnr, opts)
    if on_attach_ then
      on_attach_(client, bufnr)
    end
  end
  config.setup(opts)
  if config.options.default_prompt and config.options.default_prompt ~= '' then
    prompt_str = config.options.default_prompt
  end
  if config.options.auto_setup_gitcommit then
    M.setup_gitcommit(config.options)
  end
end

function M.setup_gitcommit(opts)
  local setup_ = function(bufnr)
    require('commit-msg-sg.executor').setup(bufnr, opts)
  end

  vim.api.nvim_create_augroup('commit-msg-sg', {
    clear = true,
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    group = 'commit-msg-sg',
    callback = function()
      setup_(vim.api.nvim_get_current_buf())
    end,
  })

  if vim.bo.filetype == 'gitcommit' then
    setup_(vim.api.nvim_get_current_buf())
  end
end

local function gen_snippet(opts, callback)
  if opts.prompt_gen then
    return opts.prompt_gen(callback)
  end

  local cwd = type(opts.cwd) == 'function' and opts.cwd() or opts.cwd
  utils.fetch_git_diff_as_text({
    cwd = cwd,
    callback = function(err, text)
      if err then
        return callback(err, nil)
      end
      local snippet = string.format(prompt_str, text)
      callback(nil, snippet)
    end,
  })
end

function M.write()
  local bufnr = vim.api.nvim_get_current_buf()
  local writter = writters[bufnr]
  if not writter or writter:invalid() then
    local Writter = require('commit-msg-sg.simple_writter')
    writters[bufnr] = Writter.init(bufnr)
    writter = writters[bufnr]
  end

  local executor = require('commit-msg-sg.executor')
  gen_snippet(config.options, function(err, snippet)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    writter:reset()
    --- NOTE: maybe move to hook.
    if config.options.ghost_text then
      utils.update_ghost_text(config.options.ghost_text)
    end
    executor.execute(bufnr, snippet, function(err_, text)
      if writter:invalid() then return end
      if err_ then
        vim.notify(err_, vim.log.levels.ERROR)
        return
      end
      if text and config.options.ghost_text then
        utils.update_ghost_text(nil)
      end
      writter:update(text)
    end)
  end)
end

return M