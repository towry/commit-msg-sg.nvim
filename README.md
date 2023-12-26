<p align="center">
  <h1 align="center">commit-msg-sg.nvim</h2>
</p>

Write git commit message with AI ([sg.nvim](https://github.com/sourcegraph/sg.nvim), [Cody](https://sourcegraph.com/cody)).

<div align="center">

https://github.com/towry/commit-msg-sg.nvim/assets/8279858/e1ac4a3b-7d6f-45ea-bee4-25674f5af424
    
</div>

## 📋 Installation

<div align="center">
<table>
<thead>
<tr>
<th>Package manager</th>
<th>
Snippet
</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[folke/lazy.nvim](https://github.com/folke/lazy.nvim)

</td>
<td>

```lua
{
  'towry/commit-msg-sg.nvim',
  dependencies = {
    'sourcegraph/sg.nvim',
  },
  -- all options are optional, you can leave it as empty table `{}`.
  opts = {
    cwd = function()
      return vim.uv.cwd()
    end,
    -- auto attach on gitcommit filetype.
    auto_setup_gitcommit = true,
    -- auto create user command `WriteGitCommitMessage`.
    auto_setup_command = true,
    -- callback when AI is started and attached to current buffer. (client, bufnr)
    -- You can create your own buffer local commands or keymaps in this callback.
    on_attach = nil,
    -- Ghost text that will be presenting when AI is working.
    ghost_text = "Thinking...",
    -- function to generate prompt string.
    -- accept a callback that takes input as prompt string.
    -- prompt_gen = function(callback)
    --   -- some async operation to generate prompt.
    --   local generated_prompt_string = 'The prompt string ...'
    --   callback(error_or_nil, generated_prompt_string)
    -- end
    prompt_gen = nil,
    -- default prompt string if you do not want to use prompt_gen.
    -- default_prompt = [[Some prompt string ... The diff content is: %s]]
    default_prompt = nil,
  },
  cmd = { 'WriteGitCommitMessage' },
  ft = 'gitcommit',
}
```

</td>
</tr>
</tbody>
</table>
</div>

## ☄ Getting started

1. Open git commit buffer in your neovim.
2. run `:WriteGitCommitMessage`.

## 🧰 Commands

| Command                  | Description                                 |
| ------------------------ | ------------------------------------------- |
| `:WriteGitCommitMessage` | Let AI write the git commit message for you |

## ⌨ Contributing

PRs and issues are always welcome. Make sure to provide as much context as possible when opening one.
