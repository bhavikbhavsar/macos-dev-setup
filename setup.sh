#!/bin/bash

# Mac Setup Script
# This script automates the setup of a new Mac for development

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if script is run on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

log_info "🚀 Starting Mac Setup..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Request sudo access upfront
log_info "This script may need sudo access for some operations."
sudo -v

# Keep-alive: update existing `sudo` timestamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    log_warning "Please complete the Xcode Command Line Tools installation and rerun this script."
    exit 0
else
    log_success "Xcode Command Line Tools already installed"
fi

# Install Homebrew
if ! command_exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    log_success "Homebrew installed successfully"
else
    log_success "Homebrew already installed"
    log_info "Updating Homebrew..."
    brew update
fi

# Install packages from Brewfile
if [[ -f "./Brewfile" ]]; then
    log_info "Installing packages from Brewfile..."
    brew bundle --file=./Brewfile
    log_success "Homebrew packages installed"
else
    log_warning "Brewfile not found, skipping package installation"
fi

# Configure macOS system preferences
if [[ -f "./macos-defaults.sh" ]]; then
    log_info "Configuring macOS system preferences..."
    chmod +x ./macos-defaults.sh
    ./macos-defaults.sh
    log_success "macOS system preferences configured"
else
    log_warning "macos-defaults.sh not found, skipping system configuration"
fi

# Setup Zsh configuration
if [[ -f "./.zshrc" ]]; then
    log_info "Setting up Zsh configuration..."
    
    # Backup existing .zshrc if it exists and is different
    if [[ -f "$HOME/.zshrc" ]] && ! cmp -s ./.zshrc "$HOME/.zshrc"; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backed up existing .zshrc"
    fi
    
    # Copy new .zshrc only if different
    if ! cmp -s ./.zshrc "$HOME/.zshrc" 2>/dev/null; then
        cp ./.zshrc "$HOME/.zshrc"
        log_info "Updated .zshrc configuration"
    else
        log_success ".zshrc already up to date"
    fi
    log_success "Zsh configuration updated"
else
    log_warning ".zshrc not found, skipping Zsh configuration"
fi

# Install Oh My Zsh (optional)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed"
else
    log_success "Oh My Zsh already installed"
fi

# Setup Python environment
if command_exists pyenv; then
    log_info "🐍 Setting up Python via pyenv..."
    
    # Install Python 3.12.5 if not already installed
    if ! pyenv versions --bare | grep -q "3.12.5"; then
        log_info "Installing Python 3.12.5..."
        pyenv install 3.12.5
    fi
    
    # Set as global version
    pyenv global 3.12.5
    pyenv rehash
    
    # Setup pipx
    if command_exists pipx; then
        log_info "Configuring pipx..."
        pipx ensurepath
        
        # Install Python development tools
        log_info "Installing Python development tools..."
        pipx install poetry || log_warning "Poetry installation failed"
        pipx install pre-commit || log_warning "pre-commit installation failed"
        
        log_success "Python environment configured"
    else
        log_warning "pipx not available, skipping Python tools installation"
    fi
else
    log_warning "pyenv not available, skipping Python setup"
fi

# Configure Zsh enhancements
log_info "🌟 Configuring Zsh enhancements..."

# Add starship prompt initialization
if ! grep -q 'eval "$(starship init zsh)"' "$HOME/.zshrc" 2>/dev/null; then
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
    log_info "Added Starship prompt initialization"
fi

# Add zsh-autosuggestions
if ! grep -q 'zsh-autosuggestions.zsh' "$HOME/.zshrc" 2>/dev/null; then
    echo 'source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$HOME/.zshrc"
    log_info "Added zsh-autosuggestions"
fi

# Add zsh-syntax-highlighting (or zsh-fast-syntax-highlighting)
if ! grep -q 'zsh-syntax-highlighting.zsh\|zsh-fast-syntax-highlighting.zsh' "$HOME/.zshrc" 2>/dev/null; then
    # Try fast syntax highlighting first, fallback to regular
    if [[ -f "$(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
        echo 'source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh' >> "$HOME/.zshrc"
        log_info "Added zsh-fast-syntax-highlighting"
    elif [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
        echo 'source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$HOME/.zshrc"
        log_info "Added zsh-syntax-highlighting"
    fi
fi

log_success "Zsh enhancements configured"

# Setup Git configuration
log_info "Setting up Git configuration..."

# Set default Git configuration (modify these with your details or comment out for interactive setup)
DEFAULT_GIT_NAME="Your Name"  # TODO: Replace with your actual name
DEFAULT_GIT_EMAIL="your.email@example.com"  # TODO: Replace with your actual email

if ! git config --global user.name > /dev/null 2>&1; then
    if [[ -n "${DEFAULT_GIT_NAME:-}" ]]; then
        git config --global user.name "$DEFAULT_GIT_NAME"
        log_info "Set Git name to: $DEFAULT_GIT_NAME"
    else
        read -p "Enter your full name for Git: " git_name
        git config --global user.name "$git_name"
    fi
fi

if ! git config --global user.email > /dev/null 2>&1; then
    if [[ -n "${DEFAULT_GIT_EMAIL:-}" ]]; then
        git config --global user.email "$DEFAULT_GIT_EMAIL"
        log_info "Set Git email to: $DEFAULT_GIT_EMAIL"
    else
        read -p "Enter your email for Git: " git_email
        git config --global user.email "$git_email"
    fi
fi

# Set some useful Git defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.editor "code --wait"

log_success "Git configuration completed"

# Setup SSH key for GitHub (optional)
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    read -p "Generate SSH key for GitHub? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git_email=$(git config --global user.email)
        ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519" -N ""
        eval "$(ssh-agent -s)"
        ssh-add "$HOME/.ssh/id_ed25519"
        
        log_success "SSH key generated"
        log_info "Add this SSH key to your GitHub account:"
        cat "$HOME/.ssh/id_ed25519.pub"
    fi
else
    log_success "SSH key already exists"
fi

# Create useful directories
log_info "Creating useful directories..."
mkdir -p "$HOME/Developer"
mkdir -p "$HOME/Desktop/Screenshots"
log_success "Directories created"

# Setup macOS screenshot location
defaults write com.apple.screencapture location "$HOME/Desktop/Screenshots"
defaults write com.apple.screencapture type "jpg"
killall SystemUIServer

# Final message
echo
log_success "🎉 Mac setup completed successfully!"
echo
log_info "Next steps:"
echo "  1. Restart your terminal or run 'source ~/.zshrc'"
echo "  2. If you generated an SSH key, add it to your GitHub account"
echo "  3. Verify Python environment: 'python --version' and 'poetry --version'"
echo "  4. Restart your Mac to ensure all system preferences take effect"
echo "  5. Open your applications and sign in as needed"
echo
log_info "Enjoy your new Mac setup! 🚀"
