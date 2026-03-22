#!/usr/bin/env bash

# =============================================
# Dotfiles Installation Script - macOS/WSL (Ubuntu)
# =============================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$(uname)" == "Darwin" ]]; then
        OS="macos"
    elif uname -r | grep -qi microsoft; then
        OS="wsl"
    else
        OS="linux"
    fi
    log_info "Detected OS: $OS"
}

# Create backup of existing config
backup_config() {
    local file=$1
    if [[ -e "$file" ]] || [[ -L "$file" ]]; then
        local backup_name="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up $file to $backup_name"
        mv "$file" "$backup_name"
    fi
}

# Create symlink
create_symlink() {
    local source=$1
    local target=$2
    
    backup_config "$target"
    
    log_info "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
    log_success "Created symlink: $target"
}

# Install tmux configuration
install_tmux() {
    log_info "Installing tmux configuration..."
    
    # Check if tmux is installed
    if ! command -v tmux &> /dev/null; then
        log_warning "tmux is not installed. Installing..."
        if [[ "$OS" == "macos" ]]; then
            if ! command -v brew &> /dev/null; then
                log_error "Homebrew not found. Please install it first."
                return 1
            fi
            brew install tmux
        elif [[ "$OS" == "wsl" ]] || [[ "$OS" == "linux" ]]; then
            sudo apt update && sudo apt install -y tmux
        fi
    fi
    
    # Create symlink
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    
    # Install TPM (Tmux Plugin Manager)
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        log_info "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log_success "TPM installed"
    fi
    
    log_success "tmux configuration installed"
}

# Install WezTerm configuration
install_wezterm() {
    log_info "Installing WezTerm configuration..."
    
    # Check if WezTerm is installed
    if ! command -v wezterm &> /dev/null; then
        log_warning "WezTerm is not installed."
        if [[ "$OS" == "macos" ]]; then
            log_info "To install WezTerm on macOS, run:"
            log_info "  brew install --cask wezterm"
        elif [[ "$OS" == "wsl" ]] || [[ "$OS" == "linux" ]]; then
            log_info "To install WezTerm on WSL/Ubuntu, visit:"
            log_info "  https://wezfurlong.org/wezterm/install/linux.html"
        fi
        log_warning "Skipping WezTerm configuration (not installed)"
        return 0
    fi
    
    # Create config directory
    local config_dir
    if [[ "$OS" == "macos" ]]; then
        config_dir="$HOME/.config/wezterm"
    else
        config_dir="$HOME/.config/wezterm"
    fi
    
    mkdir -p "$config_dir"
    
    # Create symlink
    create_symlink "$DOTFILES_DIR/wezterm/wezterm.lua" "$config_dir/wezterm.lua"
    
    log_success "WezTerm configuration installed"
}

# Install Oh My Posh configuration
install_oh_my_posh() {
    log_info "Installing Oh My Posh configuration..."
    
    # Check if Oh My Posh is installed
    if ! command -v oh-my-posh &> /dev/null; then
        log_warning "Oh My Posh is not installed. Installing..."
        if [[ "$OS" == "macos" ]]; then
            brew install jandedobbeleer/oh-my-posh/oh-my-posh
        elif [[ "$OS" == "wsl" ]] || [[ "$OS" == "linux" ]]; then
            sudo sh -c 'curl -s https://ohmyposh.dev/install.sh | bash -s'
        fi
    fi
    
    # Create config directory
    local config_dir="$HOME/.poshthemes"
    mkdir -p "$config_dir"
    
    # Copy theme files
    log_info "Copying Oh My Posh themes..."
    cp "$DOTFILES_DIR/oh-my-posh/"*.omp.json "$config_dir/"
    
    # Setup shell configuration
    setup_shell_config
    
    log_success "Oh My Posh configuration installed"
}

# Setup shell configuration
setup_shell_config() {
    local shell_config
    local posh_config
    
    if [[ "$OS" == "macos" ]]; then
        posh_config="$DOTFILES_DIR/oh-my-posh/posh-macos.omp.json"
    else
        posh_config="$DOTFILES_DIR/oh-my-posh/posh-wsl.omp.json"
    fi
    
    # Detect shell
    if [[ -n "$ZSH_VERSION" ]] || [[ -f "$HOME/.zshrc" ]]; then
        shell_config="$HOME/.zshrc"
        setup_zsh "$shell_config" "$posh_config"
    elif [[ -n "$BASH_VERSION" ]] || [[ -f "$HOME/.bashrc" ]]; then
        shell_config="$HOME/.bashrc"
        setup_bash "$shell_config" "$posh_config"
    fi
}

# Setup Zsh configuration
setup_zsh() {
    local shell_config=$1
    local posh_config=$2
    
    log_info "Setting up Zsh configuration..."
    
    # Add Oh My Posh initialization
    if ! grep -q "oh-my-posh" "$shell_config" 2>/dev/null; then
        echo "" >> "$shell_config"
        echo "# Oh My Posh" >> "$shell_config"
        echo "eval \"\$(oh-my-posh init zsh --config $posh_config)\"" >> "$shell_config"
        log_success "Added Oh My Posh to .zshrc"
    else
        log_info "Oh My Posh already configured in .zshrc"
    fi
}

# Setup Bash configuration
setup_bash() {
    local shell_config=$1
    local posh_config=$2
    
    log_info "Setting up Bash configuration..."
    
    # Add Oh My Posh initialization
    if ! grep -q "oh-my-posh" "$shell_config" 2>/dev/null; then
        echo "" >> "$shell_config"
        echo "# Oh My Posh" >> "$shell_config"
        echo "eval \"\$(oh-my-posh init bash --config $posh_config)\"" >> "$shell_config"
        log_success "Added Oh My Posh to .bashrc"
    else
        log_info "Oh My Posh already configured in .bashrc"
    fi
}

# Install fonts
install_fonts() {
    log_info "Checking for Nerd Fonts..."
    
    if [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            brew tap homebrew/cask-fonts 2>/dev/null || true
            brew install --cask font-jetbrains-mono-nerd-font 2>/dev/null || log_warning "JetBrains Mono Nerd Font may already be installed"
        fi
    elif [[ "$OS" == "wsl" ]] || [[ "$OS" == "linux" ]]; then
        log_info "To install JetBrains Mono Nerd Font on WSL/Ubuntu:"
        log_info "  1. Download from: https://www.nerdfonts.com/font-downloads"
        log_info "  2. Extract to ~/.local/share/fonts/"
        log_info "  3. Run: fc-cache -fv"
    fi
    
    log_success "Font installation complete"
}

# Main installation function
main() {
    echo "============================================="
    echo "  Dotfiles Installation Script"
    echo "============================================="
    echo ""
    
    detect_os
    
    echo ""
    echo "Select what to install:"
    echo "  1. tmux configuration"
    echo "  2. WezTerm configuration"
    echo "  3. Oh My Posh configuration"
    echo "  4. Nerd Fonts"
    echo "  5. All of the above"
    echo "  6. Exit"
    echo ""
    
    read -p "Enter your choice (1-6): " choice
    
    case $choice in
        1)
            install_tmux
            ;;
        2)
            install_wezterm
            ;;
        3)
            install_oh_my_posh
            ;;
        4)
            install_fonts
            ;;
        5)
            install_tmux
            install_wezterm
            install_oh_my_posh
            install_fonts
            ;;
        6)
            log_info "Exiting..."
            exit 0
            ;;
        *)
            log_error "Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    log_success "Installation complete!"
    echo ""
    echo "============================================="
    echo "  Next Steps:"
    echo "============================================="
    echo "  - For tmux: Restart tmux or run 'tmux kill-server'"
    echo "  - For WezTerm: Restart WezTerm"
    echo "  - For Oh My Posh: Restart your terminal or run 'source ~/.bashrc' / 'source ~/.zshrc'"
    echo "============================================="
}

# Run main function
main "$@"
