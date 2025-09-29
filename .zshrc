# Zsh Configuration for Mac Setup
# This file contains useful aliases, functions, and configurations for development

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(
    git
    brew
    macos
    docker
    npm
    node
    python
    rust
    golang
    vscode
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Load Oh My Zsh if available
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    source $ZSH/oh-my-zsh.sh
fi

# Homebrew setup for Apple Silicon Macs
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
else
    export EDITOR='code'
fi

# ============================================================================
# ALIASES
# ============================================================================

# General aliases
alias ll='exa -la --git'
alias la='exa -la'
alias l='exa -l'
alias ls='exa'
alias tree='exa --tree'

# Git aliases (additional to oh-my-zsh git plugin)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias glog='git log --oneline --decorate --graph'
alias gclean='git clean -fd'

# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dexec='docker exec -it'
alias dlogs='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias dclean='docker system prune -af'

# macOS specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias spotoff='sudo mdutil -a -i off'
alias spoton='sudo mdutil -a -i on'
alias flush='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# Development aliases
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias npmlist='npm list -g --depth=0'
alias weather='curl wttr.in'
alias ip='curl ifconfig.me'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# File operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# ============================================================================
# FUNCTIONS
# ============================================================================

# Create a new directory and enter it
mkcd() {
    mkdir -p "$@" && cd "$_";
}

# Extract archives of any type
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Get current git branch
git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Quick git commit and push
gitcp() {
    git add .
    git commit -m "$1"
    git push
}

# Find process by name and kill it
killport() {
    lsof -ti:$1 | xargs kill -9
}

# Create a backup of a file
backup() {
    cp "$1"{,.backup}
}

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Node.js
export NODE_OPTIONS="--max-old-space-size=8192"

# Python
export PYTHONDONTWRITEBYTECODE=1

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILESIZE=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ============================================================================
# ADDITIONAL TOOLS SETUP
# ============================================================================

# FZF (Fuzzy Finder)
if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    # Use ripgrep for FZF if available
    if command -v rg >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
    fi
fi

# Zsh autosuggestions
if [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Zsh syntax highlighting
if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================================
# LOCAL CUSTOMIZATIONS
# ============================================================================

# Source local .zshrc if it exists (for machine-specific settings)
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# Welcome message
echo "🚀 Welcome to your Mac development environment!"
