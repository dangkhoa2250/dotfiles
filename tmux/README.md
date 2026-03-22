# Tmux Configuration

Modern Tmux configuration for productive terminal workflows.

## Features

- Custom status bar with system info
- Easy pane navigation (`Ctrl+hjkl`)
- Session management
- Mouse support
- Vi mode for copy/scroll

## Installation

```bash
# From dotfiles root
./install.sh tmux

# Or manually
ln -s $(pwd)/tmux/.tmux.conf ~/.tmux.conf
```

## Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+a` | Prefix key |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a c` | Create new window |
| `Ctrl+a n/p` | Next/prev window |
| `Ctrl+a d` | Detach session |
| `Ctrl+a s` | List sessions |
| `Ctrl+a [` | Enter copy mode |

## Requirements

- Tmux 3.0+
