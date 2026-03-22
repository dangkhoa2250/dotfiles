#!/usr/bin/env bash

set -e

echo "========================================="
echo "  Move Neovim to Dotfiles Repository"
echo "========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="/home/khoattd3"

cd "$HOME_DIR"

# Step 1: Check if nvim folder exists
echo "Step 1: Checking nvim folder..."
if [ ! -d "nvim" ]; then
    echo "❌ Folder ~/nvim not found!"
    exit 1
fi
echo "✓ Found ~/nvim"
echo ""

# Step 2: Clone or pull dotfiles repo
echo "Step 2: Setting up dotfiles repo..."
if [ ! -d "dotfiles" ]; then
    echo "Cloning dotfiles repo..."
    git clone git@github.com:dangkhoa2250/dotfiles.git dotfiles
else
    echo "Dotfiles repo already exists"
fi

cd dotfiles
git pull origin main 2>/dev/null || echo "Could not pull, will push later"
echo "✓ Dotfiles repo ready"
echo ""

# Step 3: Create nvim folder and copy files
echo "Step 3: Copying Neovim config to dotfiles/nvim/..."
mkdir -p nvim
rm -rf nvim/*
cp -r "$SCRIPT_DIR/"* nvim/ 2>/dev/null || true

# Remove files that shouldn't be in nvim folder
rm -f nvim/dotfiles-*.md
rm -f nvim/dotfiles-*.sh
rm -f nvim/setup-dotfiles.sh
echo "✓ Copied to dotfiles/nvim/"
echo ""

# Step 4: Copy other app READMEs
echo "Step 4: Setting up other applications..."

# Tmux
if [ ! -d "tmux" ]; then
    mkdir -p tmux
fi
if [ -f "$SCRIPT_DIR/tmux-readme.md" ]; then
    cp "$SCRIPT_DIR/tmux-readme.md" tmux/README.md
    echo "✓ Tmux README created"
fi

# WezTerm
if [ ! -d "wezterm" ]; then
    mkdir -p wezterm
fi
if [ -f "$SCRIPT_DIR/wezterm-readme.md" ]; then
    cp "$SCRIPT_DIR/wezterm-readme.md" wezterm/README.md
    echo "✓ WezTerm README created"
fi

# Oh My Posh
if [ ! -d "oh-my-posh" ]; then
    mkdir -p oh-my-posh
fi
if [ -f "$SCRIPT_DIR/oh-my-posh-readme.md" ]; then
    cp "$SCRIPT_DIR/oh-my-posh-readme.md" oh-my-posh/README.md
    echo "✓ Oh My Posh README created"
fi

echo ""

# Step 5: Copy main README and install.sh
echo "Step 5: Setting up main dotfiles files..."
if [ -f "$SCRIPT_DIR/dotfiles-readme.md" ]; then
    cp "$SCRIPT_DIR/dotfiles-readme.md" README.md
    echo "✓ Main README created"
fi

if [ -f "$SCRIPT_DIR/dotfiles-install.sh" ]; then
    cp "$SCRIPT_DIR/dotfiles-install.sh" install.sh
    chmod +x install.sh
    echo "✓ install.sh created"
fi

echo ""

# Step 6: Git status
echo "Step 6: Git status..."
git status
echo ""

echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  cd /home/khoattd3/dotfiles"
echo "  git add ."
echo "  git commit -m 'feat: add neovim and app READMEs'"
echo "  git push -u origin main"
echo ""
echo "For nvim subfolder (optional separate branch):"
echo "  cd nvim"
echo "  git init"
echo "  git remote add origin git@github.com:dangkhoa2250/dotfiles.git"
echo "  git add ."
echo "  git commit -m 'feat: neovim config'"
echo "  git push -u origin nvim"
echo ""
