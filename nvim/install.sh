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

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to install packages
install_packages() {
  log_info "Installing dependencies..."
  
  case "$OS_TYPE" in
    linux)
      if command -v apt &> /dev/null; then
        echo "  → Using apt..."
        sudo apt update
        sudo apt install -y git curl ripgrep fd-find build-essential universal-ctags
      elif command -v dnf &> /dev/null; then
        echo "  → Using dnf..."
        sudo dnf install -y git curl ripgrep fd-find make gcc gcc-c++ ctags
      elif command -v pacman &> /dev/null; then
        echo "  → Using pacman..."
        sudo pacman -Syu --noconfirm git curl ripgrep fd base-devel ctags
      elif command -v zypper &> /dev/null; then
        echo "  → Using zypper..."
        sudo zypper install -y git curl ripgrep fd-find make gcc ctags
      else
        log_warn "Unknown package manager. Please install: git, curl, ripgrep, fd, ctags"
      fi
      ;;
    wsl)
      echo "  → Using apt (WSL)..."
      sudo apt update
      sudo apt install -y git curl ripgrep fd-find build-essential universal-ctags
      ;;
    mac)
      echo "  → Using Homebrew..."
      if ! command -v brew &> /dev/null; then
        log_error "Homebrew not found!"
        echo "    Install it with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
      fi
      brew install git curl ripgrep fd universal-ctags
      ;;
  esac
}

# Check and install Neovim 0.10+
install_neovim() {
  echo ""
  log_info "Checking Neovim version..."

  if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "0.0.0")
    NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
    NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)

    echo "  Current version: $NVIM_VERSION"

    if [ "$NVIM_MAJOR" -lt 0 ] || ([ "$NVIM_MAJOR" -eq 0 ] && [ "$NVIM_MINOR" -lt 10 ]); then
      log_warn "Neovim 0.10+ required. Installing..."
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
          curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
          sudo rm -rf /opt/nvim
          sudo tar -C /opt -xzf nvim-linux64.tar.gz
          rm nvim-linux64.tar.gz
          log_info "Add to PATH: export PATH=/opt/nvim-linux64/bin:\$PATH"
          ;;
      esac
    else
      log_info "Neovim version OK!"
    fi
  else
    log_warn "Neovim not found. Installing..."
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
        log_info "Add to PATH: export PATH=/opt/nvim-linux64/bin:\$PATH"
        ;;
    esac
  fi
}

# Install Node.js (for LSP)
install_nodejs() {
  echo ""
  log_info "Checking Node.js..."
  
  if command -v node &> /dev/null; then
    log_info "Node.js already installed: $(node --version)"
  else
    log_warn "Installing Node.js..."
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
  fi
}

# Create symlink
create_symlink() {
  echo ""
  log_info "Creating symlink..."

  CONFIG_DIR="$HOME/.config/nvim"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [ -L "$CONFIG_DIR" ]; then
    rm "$CONFIG_DIR"
  elif [ -d "$CONFIG_DIR" ]; then
    # Backup existing config
    BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    log_warn "Backing up existing config to $BACKUP_DIR"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
  fi

  ln -s "$SCRIPT_DIR" "$CONFIG_DIR"
  log_info "Symlink created: $CONFIG_DIR -> $SCRIPT_DIR"
}

# Create undodir
create_undodir() {
  log_info "Creating undodir..."
  mkdir -p "$HOME/.vim/undodir"
}

# Run installations
install_packages
install_neovim
install_nodejs
create_symlink
create_undodir

echo ""
echo "========================================="
echo "  ${GREEN}Installation Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Open Neovim: ${YELLOW}nvim${NC}"
echo "  2. Lazy.nvim will auto-install plugins"
echo "  3. Wait for installation to complete"
echo ""
echo "After first launch:"
echo "  - Run ${YELLOW}:Lazy sync${NC} to update plugins"
echo "  - Run ${YELLOW}:Mason${NC} to install LSP servers"
echo ""
