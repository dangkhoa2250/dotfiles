# Neovim Configuration

A modern, cross-platform Neovim configuration built with Lua and Lazy.nvim.

## ✨ Features

- **🎨 Beautiful UI**: Rose Pine theme with transparency support
- **⚡ Fast**: Lazy.nvim for optimized plugin loading
- **🔧 Full LSP Support**: Autocomplete, go-to-definition, diagnostics
- **📦 Smart Completion**: nvim-cmp with icons
- **🚀 Productivity**: Telescope, Harpoon, Which-Key
- **🌐 Cross-Platform**: Works on Linux, macOS, and WSL

## 📋 Requirements

- **Neovim 0.10+** (required)
- **Node.js** (for LSP features)
- **Git**
- **Nerd Font** (for icons - recommended: JetBrainsMono Nerd Font)

## 🚀 Quick Install

### Linux & macOS

```bash
# Clone the repository
git clone https://github.com/dangkhoa2250/nvim_setup.git ~/.config/nvim

# Run the installer
cd ~/.config/nvim
./install.sh
```

### Manual Install

```bash
# Clone
git clone https://github.com/dangkhoa2250/nvim_setup.git ~/.config/nvim

# Open Neovim (Lazy.nvim will auto-install plugins)
nvim
```

## 📦 Plugin Manager

This config uses **Lazy.nvim**. Plugins are installed automatically on first launch.

### Useful Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open Lazy.nvim UI |
| `:Lazy sync` | Update all plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Mason` | Open Mason UI (LSP tools) |
| `:MasonInstall <lang>` | Install LSP server |

## ⌨️ Key Bindings

### Leader Key: `<Space>`

#### General
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>f` | Format code |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>mr` | Make it rain (fun!) |

#### Navigation
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| `<C-d/u>` | Scroll down/up (centered) |
| `n/N` | Search next/prev (centered) |
| `J` | Move line down |
| `K` | Move line up |

#### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>vrn` | Rename symbol |
| `<leader>vca` | Code action |
| `[d` / `]d` | Next/prev diagnostic |

#### Harpoon (File Bookmarks)
| Key | Action |
|-----|--------|
| `<leader>a` | Add file to Harpoon |
| `<C-e>` | Toggle Harpoon menu |
| `<C-h/j/k/l>` | Jump to file 1/2/3/4 |

#### Commenting
| Key | Action |
|-----|--------|
| `,cc` | Comment line/block |
| `,cu` | Uncomment line/block |

## 🎨 Customization

### Change Theme

Edit `lua/core/plugins/init.lua`:

```lua
{
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "moon",  -- Options: auto, main, moon, dawn
    })
    vim.cmd("colorscheme rose-pine")
  end,
}
```

### Add New Plugins

Edit `lua/core/plugins/init.lua` and add to the return table:

```lua
{
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end,
},
```

### Modify Keybindings

Edit `lua/core/remap.lua`

### Modify Settings

Edit `lua/core/set.lua`

## 🖥️ Terminal Setup

### WezTerm (Recommended)

Create `~/.wezterm.lua`:

```lua
local wezterm = require 'wezterm'

return {
  font = wezterm.font 'JetBrainsMono Nerd Font',
  font_size = 13.0,
  color_scheme = 'Rose Pine',
  window_background_opacity = 0.85,
  text_background_opacity = 1.0,
  enable_tab_bar = false,
  window_decorations = 'RESIZE',
}
```

### Install Nerd Font

```bash
# macOS
brew install --cask font-jetbrains-mono-nerd-font

# Linux (manual)
# Download from https://www.nerdfonts.com/font-downloads
# Extract to ~/.local/share/fonts/
# fc-cache -fv
```

## 🐛 Troubleshooting

### Icons not showing
- Install a Nerd Font
- Set terminal font to the Nerd Font

### Transparency not working
- Configure your terminal's opacity settings
- Rose Pine is configured with `disable_background = true`

### LSP not working
```vim
:Mason
" Install required LSP servers
```

### Plugins not loading
```vim
:Lazy sync
:Lazy clean
:qa  " Quit and reopen
```

## 📁 Project Structure

```
.
├── init.lua                 # Entry point
├── install.sh               # Installation script
├── lazy-lock.json           # Plugin versions lock
├── lua/
│   └── core/
│       ├── init.lua         # Core module loader
│       ├── set.lua          # Settings/options
│       ├── remap.lua        # Key mappings
│       ├── lazy.lua         # Lazy.nvim config
│       ├── lsp.lua          # LSP configuration
│       └── plugins/
│           └── init.lua     # Plugin definitions
└── README.md
```

## 🙏 Credits

- [ThePrimeagen](https://github.com/ThePrimeagen) - Inspiration and Neovim tutorials
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Rose Pine](https://github.com/rose-pine/neovim) - Beautiful theme

## 📄 License

MIT
