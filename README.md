# Dotfiles

My personal configuration for various development tools and terminal applications.

## 🎯 Purpose

This repository contains all my configuration files for setting up a productive development environment across multiple machines (macOS, Linux, WSL).

## 📦 Applications

| Application | Description | Config Path |
|-------------|-------------|-------------|
| **Neovim** | Modern text editor with LSP support | [`nvim/`](./nvim/) |
| **Tmux** | Terminal multiplexer | [`tmux/`](./tmux/) |
| **WezTerm** | GPU-accelerated terminal emulator | [`wezterm/`](./wezterm/) |
| **Oh My Posh** | Cross-platform prompt theme engine | [`oh-my-posh/`](./oh-my-posh/) |

## 🚀 Quick Start

### Clone & Install

```bash
# Clone the repository
git clone git@github.com:dangkhoa2250/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installer
./install.sh
```

### Install Specific Application

```bash
# Install only Neovim config
./install.sh nvim

# Install only Tmux config
./install.sh tmux

# Install only WezTerm config
./install.sh wezterm
```

## 📁 Structure

```
dotfiles/
├── nvim/              # Neovim configuration
│   ├── init.lua
│   ├── lua/
│   ├── install.sh
│   └── README.md
├── tmux/              # Tmux configuration
│   ├── .tmux.conf
│   └── README.md
├── wezterm/           # WezTerm configuration
│   ├── wezterm.lua
│   └── README.md
├── oh-my-posh/        # Oh My Posh themes
│   ├── posh-macos.omp.json
│   ├── posh-wsl.omp.json
│   └── README.md
├── install.sh         # Main installation script
└── README.md          # This file
```

## 🖥️ Supported Platforms

- **macOS** (Sonoma+)
- **Linux** (Ubuntu, Fedora, Arch)
- **WSL2** (Windows Subsystem for Linux)

## 🎨 Features

### Neovim
- Rose Pine theme with transparency
- Full LSP support (TypeScript, Lua, Rust, Python)
- Telescope for fuzzy finding
- Harpoon for quick file navigation
- Which-Key for keybinding hints

### Tmux
- Custom status bar
- Easy pane navigation
- Session management

### WezTerm
- GPU acceleration
- Ligature support
- Rose Pine colorscheme
- Transparency

### Oh My Posh
- Beautiful prompt themes
- Git status indicators
- Cross-platform consistency

## 🔧 Requirements

- **Neovim** 0.10+
- **Tmux** 3.0+
- **WezTerm** (latest)
- **Oh My Posh** (latest)
- **Nerd Font** (JetBrainsMono recommended)

## 📝 Setup Guides

Each application has its own README with detailed setup instructions:

- [Neovim Setup](./nvim/README.md)
- [Tmux Setup](./tmux/README.md)
- [WezTerm Setup](./wezterm/README.md)
- [Oh My Posh Setup](./oh-my-posh/README.md)

## 🔄 Updates

```bash
cd ~/.dotfiles
git pull
./install.sh
```

## 📄 License

MIT
