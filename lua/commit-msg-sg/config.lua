local CommitMsgSg = {}

--- Your plugin configuration with its default values.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
CommitMsgSg.options = {
  ---@type string|function
  cwd = nil,
  auto_setup_gitcommit = true,
  auto_setup_command = true,
  on_attach = nil,
  ghost_text = "Thinking...",
  -- customized function to generate prompt string.
  prompt_gen = nil,
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
