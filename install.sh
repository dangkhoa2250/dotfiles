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
  echo "  nvim       - Neovim configuration"
  echo "  tmux       - Tmux configuration"
  echo "  wezterm    - WezTerm configuration"
  echo "  oh-my-posh - Oh My Posh themes"
  echo "  all        - Install everything"
  echo "  help       - Show this help"
  echo ""
  echo "Examples:"
  echo "  $0              # Interactive menu"
  echo "  $0 nvim         # Install only Neovim"
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
  
  echo "✓ Tmux installed"
  echo ""
}

# Install WezTerm
install_wezterm() {
  echo "========================================="
  echo "  Installing WezTerm Configuration"
  echo "========================================="
  
  local WEZTERM_CONF="$HOME/.wezterm.lua"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
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
  
  local POSH_DIR="$HOME/.poshthemes"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  # Create directory
  mkdir -p "$POSH_DIR"
  
  # Copy themes
  cp "$SCRIPT_DIR/oh-my-posh/"*.omp.json "$POSH_DIR/" 2>/dev/null || true
  echo "Oh My Posh themes copied to: $POSH_DIR"
  
  echo "✓ Oh My Posh installed"
  echo ""
  echo "Add to your shell config (bash):"
  echo "  echo 'eval \"\$(oh-my-posh init bash --config ~/.poshthemes/posh-macos.omp.json)\"' >> ~/.bashrc"
  echo ""
}

# Install all
install_all() {
  install_nvim
  install_tmux
  install_wezterm
  install_oh_my_posh
}

# Interactive menu
interactive_menu() {
  echo "What would you like to install?"
  echo ""
  echo "  1) Neovim"
  echo "  2) Tmux"
  echo "  3) WezTerm"
  echo "  4) Oh My Posh"
  echo "  5) All of the above"
  echo "  6) Quit"
  echo ""

  local choices=""
  while true; do
    read -p "Enter your choice (1-6): " choice
    case "$choice" in
      1) choices="nvim"; break ;;
      2) choices="tmux"; break ;;
      3) choices="wezterm"; break ;;
      4) choices="oh-my-posh"; break ;;
      5) choices="all"; break ;;
      6) echo "Exiting..."; exit 0 ;;
      *) echo "Invalid choice. Please enter 1-6." ;;
    esac
  done

  echo ""

  case "$choices" in
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
