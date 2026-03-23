#!/usr/bin/env bash

set -e

echo "========================================="
echo "  Dotfiles Installer"
echo "  For macOS, Linux, and WSL"
echo "========================================="
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*)
    if grep -q "microsoft" /proc/version 2>/dev/null; then
      OS_TYPE="wsl"
      echo "Detected: WSL"
    else
      OS_TYPE="linux"
      echo "Detected: Linux"
    fi
    ;;
  Darwin*)
    OS_TYPE="mac"
    echo "Detected: macOS"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    OS_TYPE="windows"
    echo "Detected: Windows"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo ""

# Function to show usage
show_usage() {
  echo "Usage: $0 [app]"
  echo ""
  echo "Available apps:"
  echo "  bash       - Bash configuration"
  echo "  zsh        - Zsh configuration"
  echo "  nvim       - Neovim configuration"
  echo "  tmux       - Tmux configuration"
  echo "  wezterm    - WezTerm configuration"
  echo "  oh-my-posh - Oh My Posh themes"
  echo "  all        - Install everything"
  echo "  help       - Show this help"
  echo ""
  echo "Examples:"
  echo "  $0              # Interactive menu"
  echo "  $0 zsh          # Install only Zsh"
  echo "  $0 all          # Install all"
  echo ""
}

# Install Neovim
install_nvim() {
  echo "========================================="
  echo "  Installing Neovim Configuration"
  echo "========================================="
  
  local NVIM_DIR="$HOME/.config/nvim"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  # Backup existing config
  if [ -L "$NVIM_DIR" ] || [ -d "$NVIM_DIR" ]; then
    echo "Backing up existing Neovim config..."
    mv "$NVIM_DIR" "$NVIM_DIR.backup.$(date +%Y%m%d)"
  fi
  
  # Create symlink
  ln -s "$SCRIPT_DIR/nvim" "$NVIM_DIR"
  echo "Neovim config linked: $NVIM_DIR -> $SCRIPT_DIR/nvim"
  
  # Run nvim installer if exists
  if [ -f "$SCRIPT_DIR/nvim/install.sh" ]; then
    bash "$SCRIPT_DIR/nvim/install.sh"
  fi
  
  echo "✓ Neovim installed"
  echo ""
}

# Install Tmux
install_tmux() {
  echo "========================================="
  echo "  Installing Tmux Configuration"
  echo "========================================="

  # Skip on Windows
  if [ "$OS_TYPE" = "windows" ]; then
    echo "Skipping Tmux on Windows..."
    return
  fi

  # Install tmux based on OS
  case "$OS_TYPE" in
    mac)
      if ! command -v tmux &> /dev/null; then
        echo "Installing Tmux via brew..."
        brew install tmux
      fi
      ;;
    wsl|linux)
      if ! command -v tmux &> /dev/null; then
        echo "Installing Tmux via apt..."
        sudo apt update && sudo apt install -y tmux
      fi
      ;;
  esac

  local TMUX_CONF="$HOME/.tmux.conf"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Backup existing config
  if [ -L "$TMUX_CONF" ] || [ -f "$TMUX_CONF" ]; then
    echo "Backing up existing .tmux.conf..."
    mv "$TMUX_CONF" "$TMUX_CONF.backup.$(date +%Y%m%d)"
  fi

  # Create symlink
  ln -s "$SCRIPT_DIR/tmux/.tmux.conf" "$TMUX_CONF"
  echo "Tmux config linked: $TMUX_CONF -> $SCRIPT_DIR/tmux/.tmux.conf"

  # Install TPM plugins
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  # Install tmux plugins
  echo "Installing tmux plugins..."
  ~/.tmux/plugins/tpm/bin/install_plugins 2>/dev/null || true

  echo "✓ Tmux installed"
  echo ""
}

# Install WezTerm
install_wezterm() {
  echo "========================================="
  echo "  Installing WezTerm Configuration"
  echo "========================================="

  # Skip on WSL/Linux (WezTerm not available)
  if [ "$OS_TYPE" = "wsl" ] || [ "$OS_TYPE" = "linux" ]; then
    echo "Skipping WezTerm on WSL/Linux..."
    return
  fi

  local WEZTERM_CONF="$HOME/.wezterm.lua"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Install based on OS
  case "$OS_TYPE" in
    mac)
      if ! command -v wezterm &> /dev/null; then
        echo "Installing WezTerm via brew..."
        brew install --cask wezterm
      fi
      ;;
    windows)
      if ! command -v wezterm &> /dev/null; then
        echo "Installing WezTerm via scoop..."
        scoop install wezterm
      fi
      ;;
  esac

  # Backup existing config
  if [ -L "$WEZTERM_CONF" ] || [ -f "$WEZTERM_CONF" ]; then
    echo "Backing up existing wezterm.lua..."
    mv "$WEZTERM_CONF" "$WEZTERM_CONF.backup.$(date +%Y%m%d)"
  fi

  # Create symlink
  ln -s "$SCRIPT_DIR/wezterm/wezterm.lua" "$WEZTERM_CONF"
  echo "WezTerm config linked: $WEZTERM_CONF -> $SCRIPT_DIR/wezterm/wezterm.lua"

  echo "✓ WezTerm installed"
  echo ""
}

# Install Oh My Posh
install_oh_my_posh() {
  echo "========================================="
  echo "  Installing Oh My Posh Configuration"
  echo "========================================="

  # Skip on Windows
  if [ "$OS_TYPE" = "windows" ]; then
    echo "Skipping Oh My Posh on Windows..."
    return
  fi

  # Install oh-my-posh based on OS
  case "$OS_TYPE" in
    mac)
      if ! command -v oh-my-posh &> /dev/null; then
        echo "Installing oh-my-posh via brew..."
        brew install oh-my-posh
      fi
      ;;
    wsl|linux)
      if ! command -v oh-my-posh &> /dev/null; then
        echo "Installing oh-my-posh via apt..."
        curl -s https://ohmyposh.dev/install.sh | bash -s
      fi
      ;;
  esac

  local POSH_DIR="$HOME/.poshthemes"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Create directory
  mkdir -p "$POSH_DIR"

  # Copy themes
  cp "$SCRIPT_DIR/oh-my-posh/"*.omp.json "$POSH_DIR/" 2>/dev/null || true
  echo "Oh My Posh themes copied to: $POSH_DIR"

  echo "✓ Oh My Posh installed"
  echo ""
}

# Install Bash
install_bash() {
  echo "========================================="
  echo "  Installing Bash Configuration"
  echo "========================================="

  local BASHRC="$HOME/.bashrc"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Backup existing config
  if [ -L "$BASHRC" ] || [ -f "$BASHRC" ]; then
    echo "Backing up existing .bashrc..."
    mv "$BASHRC" "$BASHRC.backup.$(date +%Y%m%d)"
  fi

  # Create symlink
  ln -s "$SCRIPT_DIR/bash/.bashrc" "$BASHRC"
  echo "Bash config linked: $BASHRC -> $SCRIPT_DIR/bash/.bashrc"

  echo "✓ Bash installed"
  echo ""
}

# Install Zsh
install_zsh() {
  echo "========================================="
  echo "  Installing Zsh Configuration"
  echo "========================================="

  local ZSHRC="$HOME/.zshrc"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Backup existing config
  if [ -L "$ZSHRC" ] || [ -f "$ZSHRC" ]; then
    echo "Backing up existing .zshrc..."
    mv "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d)"
  fi

  # Create symlink
  ln -s "$SCRIPT_DIR/zsh/.zshrc" "$ZSHRC"
  echo "Zsh config linked: $ZSHRC -> $SCRIPT_DIR/zsh/.zshrc"

  echo "✓ Zsh installed"
  echo ""
}

# Install all
install_all() {
  install_bash
  install_zsh
  install_nvim
  install_tmux
  install_wezterm
  install_oh_my_posh
}

# Interactive menu
interactive_menu() {
  echo "What would you like to install?"
  echo ""
  echo "  1) Bash"
  echo "  2) Zsh"
  echo "  3) Neovim"
  echo "  4) Tmux"
  echo "  5) WezTerm"
  echo "  6) Oh My Posh"
  echo "  7) All of the above"
  echo "  8) Quit"
  echo ""

  local choices=""
  while true; do
    read -p "Enter your choice (1-8): " choice
    case "$choice" in
      1) choices="bash"; break ;;
      2) choices="zsh"; break ;;
      3) choices="nvim"; break ;;
      4) choices="tmux"; break ;;
      5) choices="wezterm"; break ;;
      6) choices="oh-my-posh"; break ;;
      7) choices="all"; break ;;
      8) echo "Exiting..."; exit 0 ;;
      *) echo "Invalid choice. Please enter 1-8." ;;
    esac
  done

  echo ""

  case "$choices" in
    bash) install_bash ;;
    zsh) install_zsh ;;
    nvim) install_nvim ;;
    tmux) install_tmux ;;
    wezterm) install_wezterm ;;
    oh-my-posh) install_oh_my_posh ;;
    all) install_all ;;
  esac
}

# Main
APP="${1:-}"

if [ -z "$APP" ]; then
  # No argument - interactive mode
  interactive_menu
else
  # Argument provided - use it
  case "$APP" in
    bash)
      install_bash
      ;;
    zsh)
      install_zsh
      ;;
    nvim)
      install_nvim
      ;;
    tmux)
      install_tmux
      ;;
    wezterm)
      install_wezterm
      ;;
    oh-my-posh)
      install_oh_my_posh
      ;;
    all)
      install_all
      ;;
    help|--help|-h)
      show_usage
      ;;
    *)
      echo "Unknown application: $APP"
      echo ""
      show_usage
      exit 1
      ;;
  esac
fi

echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
echo "Restart your terminal or run:"
echo "  source ~/.bashrc    # for bash"
echo "  source ~/.zshrc     # for zsh"
echo ""
