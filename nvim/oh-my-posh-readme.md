# Oh My Posh Configuration

Cross-platform prompt theme engine for beautiful terminal prompts.

## Features

- Git status indicators
- Execution time display
- Custom themes for macOS and WSL
- Consistent look across platforms

## Installation

```bash
# From dotfiles root
./install.sh oh-my-posh

# Or manually install Oh My Posh first
# macOS
brew install janDeDobbeleer.oh-my-posh

# Linux
sudo sh -c 'curl -s https://ohmyposh.dev/install.sh | bash'

# Then symlink themes
ln -s $(pwd)/oh-my-posh/*.omp.json ~/.poshthemes/
```

## Usage

### PowerShell
Add to your `$PROFILE`:
```powershell
oh-my-posh init pwsh --config ~/.poshthemes/posh-macos.omp.json | Invoke-Expression
```

### Bash/Zsh
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
eval "$(oh-my-posh init bash --config ~/.poshthemes/posh-wsl.omp.json)"
```

## Themes

| Theme | Platform |
|-------|----------|
| `posh-macos.omp.json` | macOS |
| `posh-wsl.omp.json` | WSL/Linux |
