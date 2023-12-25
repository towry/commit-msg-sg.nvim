<p align="center">
  <h1 align="center">commit-msg-sg.nvim</h2>
</p>

<p align="center">
Write git commit message with AI (sg.nvim).
</p>

<div align="center">
    > Drag your video (<10MB) here to host it for free on GitHub.
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
  opts = {
    -- see doc
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

## 🗞 Wiki

You can find guides and showcase of the plugin on [the Wiki](https://github.com/towry/commit-msg-sg.nvim/wiki)

## 🎭 Motivations

> If alternatives of your plugin exist, you can provide some pros/cons of using yours over the others.
