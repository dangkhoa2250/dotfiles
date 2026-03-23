#!/usr/bin/env bash

set -e

echo "========================================="
echo "  Neovim Config Installer"
echo "  For Linux, macOS, and WSL"
echo "========================================="
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Linux*)
    if grep -q "microsoft" /proc/version 2>/dev/null; then
      echo "Detected: WSL"
      OS_TYPE="wsl"
    else
      echo "Detected: Linux"
      OS_TYPE="linux"
    fi
    ;;
  Darwin*)
    echo "Detected: macOS"
    OS_TYPE="mac"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo ""

# Function to install packages
install_packages() {
  case "$OS_TYPE" in
    linux)
      if command -v apt &> /dev/null; then
        echo "Installing dependencies with apt..."
        sudo apt update
        sudo apt install -y git curl ripgrep fd-find build-essential universal-ctags
      elif command -v dnf &> /dev/null; then
        echo "Installing dependencies with dnf..."
        sudo dnf install -y git curl ripgrep fd-find make gcc gcc-c++ ctags
      elif command -v pacman &> /dev/null; then
        echo "Installing dependencies with pacman..."
        sudo pacman -Syu --noconfirm git curl ripgrep fd base-devel ctags
      fi
      ;;
    wsl)
      echo "Installing dependencies with apt (WSL)..."
      sudo apt update
      sudo apt install -y git curl ripgrep fd-find build-essential universal-ctags
      ;;
    mac)
      echo "Installing dependencies with Homebrew..."
      if ! command -v brew &> /dev/null; then
        echo "Homebrew not found! Please install it first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
      fi
      brew install git curl ripgrep fd universal-ctags
      ;;
  esac
}

# Check and install Neovim 0.10+
install_neovim() {
  echo ""
  echo "Checking Neovim version..."
  
  if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "0.0.0")
    NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
    NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
    
    echo "Current Neovim version: $NVIM_VERSION"
    
    if [ "$NVIM_MAJOR" -lt 0 ] || ([ "$NVIM_MAJOR" -eq 0 ] && [ "$NVIM_MINOR" -lt 10 ]); then
      echo "Neovim 0.10+ required. Installing..."
      case "$OS_TYPE" in
        linux)
          if command -v apt &> /dev/null; then
            sudo apt install -y software-properties-common
            sudo add-apt-repository -y ppa:neovim-ppa/unstable
            sudo apt update
            sudo apt install -y neovim
          fi
          ;;
        mac)
          brew install --HEAD neovim
          ;;
        wsl)
          # Install from GitHub release
          curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
          sudo rm -rf /opt/nvim
          sudo tar -C /opt -xzf nvim-linux64.tar.gz
          rm nvim-linux64.tar.gz
          echo "Add to your PATH: export PATH=/opt/nvim-linux64/bin:\$PATH"
          ;;
      esac
    else
      echo "Neovim version OK!"
    fi
  else
    echo "Neovim not found. Installing..."
    case "$OS_TYPE" in
      linux)
        if command -v apt &> /dev/null; then
          sudo apt install -y neovim
        elif command -v dnf &> /dev/null; then
          sudo dnf install -y neovim
        elif command -v pacman &> /dev/null; then
          sudo pacman -Syu --noconfirm neovim
        fi
        ;;
      mac)
        brew install neovim
        ;;
      wsl)
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        rm nvim-linux64.tar.gz
        echo "Add to your PATH: export PATH=/opt/nvim-linux64/bin:\$PATH"
        ;;
    esac
  fi
}

# Install Node.js (for LSP)
install_nodejs() {
  echo ""
  echo "Checking Node.js..."
  if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    case "$OS_TYPE" in
      linux|wsl)
        if command -v apt &> /dev/null; then
          sudo apt install -y nodejs npm
        elif command -v dnf &> /dev/null; then
          sudo dnf install -y nodejs npm
        elif command -v pacman &> /dev/null; then
          sudo pacman -Syu --noconfirm nodejs npm
        fi
        ;;
      mac)
        brew install node
        ;;
    esac
  else
    echo "Node.js already installed: $(node --version)"
  fi
}

# Create symlink
create_symlink() {
  echo ""
  echo "Creating symlink..."
  
  CONFIG_DIR="$HOME/.config/nvim"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  if [ -L "$CONFIG_DIR" ]; then
    rm "$CONFIG_DIR"
  elif [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
  fi
  
  ln -s "$SCRIPT_DIR" "$CONFIG_DIR"
  echo "Symlink created: $CONFIG_DIR -> $SCRIPT_DIR"
}

# Create undodir
create_undodir() {
  echo ""
  echo "Creating undodir..."
  mkdir -p "$HOME/.vim/undodir"
  echo "Undodir created: $HOME/.vim/undodir"
}

# Run installations
install_packages
install_neovim
install_nodejs
create_symlink
create_undodir

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Open Neovim: nvim"
echo "  2. Lazy.nvim will auto-install plugins"
echo "  3. Wait for installation to complete"
echo ""
echo "After first launch, you can:"
echo "  - Run :Lazy sync to update plugins"
echo "  - Run :Mason to install LSP servers"
echo ""
