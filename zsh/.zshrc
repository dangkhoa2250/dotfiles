# ~/.zshrc: executed by zsh(1) for non-login shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History
HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.zsh_history
setopt histappend
setopt SHARE_HISTORY

# Fix Vietnamese IME input for claude code
export NODE_READLINE_TYPE="generic"

# Add ~/bin to PATH
export PATH="$HOME/bin:$PATH"

# Terminal title
case "$TERM" in
xterm*|rxvt*)
    print -Pn "\e]0;%n@%m: %~\a"
    ;;
esac

# Color support for ls
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias pa='cd ~/project/FA.ACE-Proposal-Agent'
alias nv='cd ~/.config/nvim'
alias sba='source ~/.zshrc'
alias n='nvim'
alias ba='nvim ~/.zshrc'
alias dt='ssh deepthink@100.77.11.124'
alias q='qwen'
alias oo='cd ~/Onedrive/Obsidian/Obsidian\ Vault'
alias og='nvim ~/Onedrive/Obsidian/Obsidian\ Vault/gomi'
# completion
autoload -Uz compinit
compinit

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Vi mode
bindkey -v

# Prompt - cross-platform
case "$(uname -s)" in
  Linux*)
    # Linux: use Oh My Posh
    if command -v oh-my-posh &> /dev/null; then
      eval "$(oh-my-posh init zsh --config ~/.poshthemes/posh-macos-simple.omp.json)"
    else
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
    fi
    ;;
  Darwin*)
    # macOS: use Oh My Posh
    if command -v oh-my-posh &> /dev/null; then
      eval "$(oh-my-posh init zsh --config ~/.poshthemes/posh-macos-simple.omp.json)"
    else
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
    fi
    ;;
esac

. "$HOME/.local/bin/env"
