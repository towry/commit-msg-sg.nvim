local CommitMsgSg = {}

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
CommitMsgSg.options = {
  -- Can be string or function that returns cwd.
  --@type string|function
  cwd = nil,
  -- auto attach on gitcommit filetype.
  auto_setup_gitcommit = true,
  -- auto create user command `WriteGitCommitMessage`.
  auto_setup_command = true,
  -- callback when AI is started and attached to current buffer. (client, bufnr)
  -- You can create your own buffer local commands or keymaps in this callback.
  on_attach = nil,
  ghost_text = "Thinking...",
  -- function to generate prompt string.
  -- accept a callback that takes input as prompt string.
  -- ```lua
  -- prompt_gen = function(callback)
  --   -- some async operation to generate prompt.
  --   local generated_prompt_string = 'The prompt string ...'
  --   callback(error_or_nil, generated_prompt_string)
  -- end
  -- ```
  prompt_gen = nil,
  -- default prompt string if you do not want to use prompt_gen.
  -- default_prompt = [[Some prompt string ... The diff content is: %s]]
  -- Note: the staged diff content is generated so you can use it in your prompt to
  -- add more context.
  default_prompt = nil,
  -- @private
  executor = "sg",
  -- Debug
  -- @private
  debug = false,
}

--- Define your commit-msg-sg setup.
---
---@param options table Module config table. See |CommitMsgSg.options|.
---
---@usage `require("commit-msg-sg").setup()` (add `{}` with your |CommitMsgSg.options| table)
function CommitMsgSg.setup(options)
  options = options or {}

  CommitMsgSg.options = vim.tbl_deep_extend("keep", options, CommitMsgSg.options)

  return CommitMsgSg.options
end

return CommitMsgSg
