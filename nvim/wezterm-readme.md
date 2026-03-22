# WezTerm Configuration

GPU-accelerated terminal emulator configuration with beautiful UI.

## Features

- Rose Pine colorscheme
- Transparency support
- Ligature support (JetBrainsMono Nerd Font)
- Tab bar disabled for minimal look
- Custom keybindings

## Installation

```bash
# From dotfiles root
./install.sh wezterm

# Or manually
ln -s $(pwd)/wezterm/wezterm.lua ~/.wezterm.lua
```

## Requirements

- WezTerm (latest)
- JetBrainsMono Nerd Font

## Install Font

### macOS
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Linux
```bash
# Download from https://www.nerdfonts.com
# Extract to ~/.local/share/fonts/
fc-cache -fv
```

## Configuration

Edit `wezterm.lua` to customize:
- Font size
- Transparency level
- Colorscheme
- Keybindings
