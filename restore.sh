#!/bin/bash

# Mac Setup Restore Script
# This script attempts to revert changes made by the setup script

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Confirmation function
confirm() {
    read -p "$(echo -e "${YELLOW}⚠️  $1 (y/N): ${NC}")" -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

echo -e "${RED}🔄 Mac Setup Restore Script${NC}"
echo
log_warning "This script will attempt to revert changes made by the Mac setup script."
log_warning "Some changes cannot be automatically reverted and will require manual intervention."
echo
log_info "What this script will do:"
echo "  • Uninstall Homebrew packages from Brewfile"
echo "  • Remove Oh My Zsh installation"
echo "  • Restore backed up .zshrc files"
echo "  • Remove Python environments installed via pyenv"
echo "  • Clean up shell profile modifications"
echo "  • Reset some macOS preferences to defaults"
echo "  • Remove created directories (optional)"
echo
log_warning "What CANNOT be automatically reverted:"
echo "  • Xcode Command Line Tools (system component)"
echo "  • All macOS system preferences (some don't have clear defaults)"
echo "  • Git global configuration (will be cleared, not restored to original)"
echo "  • SSH keys (will be removed entirely)"
echo
if ! confirm "Do you want to proceed with the restoration?"; then
    log_info "Restoration cancelled."
    exit 0
fi

# Request sudo access upfront
log_info "This script may need sudo access for some operations."
sudo -v

# Keep-alive: update existing `sudo` timestamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Homebrew Package Removal                                                   #
###############################################################################

if command_exists brew && [[ -f "./Brewfile" ]]; then
    if confirm "Remove Homebrew packages installed from Brewfile?"; then
        log_info "Removing Homebrew packages..."
        
        # Remove casks first (applications)
        log_info "Removing applications (casks)..."
        grep "^cask " ./Brewfile | sed 's/cask "\(.*\)".*/\1/' | while read -r cask; do
            if brew list --cask | grep -q "^${cask}$"; then
                brew uninstall --cask "$cask" 2>/dev/null || log_warning "Failed to remove $cask"
            fi
        done
        
        # Remove formulae (CLI tools)
        log_info "Removing CLI tools (formulae)..."
        grep "^brew " ./Brewfile | sed 's/brew "\(.*\)".*/\1/' | while read -r formula; do
            if brew list | grep -q "^${formula}$"; then
                brew uninstall "$formula" 2>/dev/null || log_warning "Failed to remove $formula"
            fi
        done
        
        # Clean up
        brew cleanup
        log_success "Homebrew packages removed"
    fi
    
    if confirm "Remove Homebrew entirely? (This will remove ALL Homebrew packages, not just from Brewfile)"; then
        log_warning "Removing Homebrew completely..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
        log_success "Homebrew removed"
    fi
else
    log_info "Homebrew not found or Brewfile not found, skipping package removal"
fi

###############################################################################
# Python Environment Cleanup                                                 #
###############################################################################

if command_exists pyenv; then
    if confirm "Remove Python 3.12.5 installed via pyenv?"; then
        log_info "Removing Python 3.12.5..."
        pyenv uninstall -f 3.12.5 2>/dev/null || log_warning "Failed to remove Python 3.12.5"
        log_success "Python 3.12.5 removed"
    fi
fi

if command_exists pipx; then
    if confirm "Remove pipx-installed packages (poetry, pre-commit)?"; then
        log_info "Removing pipx packages..."
        pipx uninstall poetry 2>/dev/null || true
        pipx uninstall pre-commit 2>/dev/null || true
        log_success "pipx packages removed"
    fi
fi

###############################################################################
# Zsh Configuration Restoration                                              #
###############################################################################

if confirm "Restore Zsh configuration?"; then
    # Find the most recent backup
    BACKUP_FILE=$(find "$HOME" -name ".zshrc.backup.*" -type f 2>/dev/null | sort -r | head -n 1)
    
    if [[ -n "$BACKUP_FILE" ]]; then
        log_info "Restoring .zshrc from backup: $(basename "$BACKUP_FILE")"
        cp "$BACKUP_FILE" "$HOME/.zshrc"
        log_success ".zshrc restored from backup"
        
        if confirm "Remove all .zshrc backup files?"; then
            rm -f "$HOME/.zshrc.backup."*
            log_success "Backup files removed"
        fi
    else
        log_warning "No .zshrc backup found"
        if confirm "Remove current .zshrc? (This will leave you with system default)"; then
            rm -f "$HOME/.zshrc"
            log_success "Current .zshrc removed"
        fi
    fi
fi

# Remove Oh My Zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    if confirm "Remove Oh My Zsh installation?"; then
        log_info "Removing Oh My Zsh..."
        rm -rf "$HOME/.oh-my-zsh"
        log_success "Oh My Zsh removed"
    fi
fi

###############################################################################
# Shell Profile Cleanup                                                      #
###############################################################################

if confirm "Remove Homebrew PATH from shell profiles?"; then
    log_info "Cleaning shell profiles..."
    
    # Remove from .zprofile
    if [[ -f "$HOME/.zprofile" ]]; then
        sed -i '' '/eval.*homebrew.*brew shellenv/d' "$HOME/.zprofile" 2>/dev/null || true
        log_info "Cleaned .zprofile"
    fi
    
    # Remove from .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        sed -i '' '/eval.*homebrew.*brew shellenv/d' "$HOME/.zshrc" 2>/dev/null || true
        sed -i '' '/eval.*starship init zsh/d' "$HOME/.zshrc" 2>/dev/null || true
        sed -i '' '/source.*zsh-autosuggestions/d' "$HOME/.zshrc" 2>/dev/null || true
        sed -i '' '/source.*zsh-syntax-highlighting/d' "$HOME/.zshrc" 2>/dev/null || true
        sed -i '' '/source.*zsh-fast-syntax-highlighting/d' "$HOME/.zshrc" 2>/dev/null || true
        log_info "Cleaned .zshrc"
    fi
    
    log_success "Shell profiles cleaned"
fi

###############################################################################
# Git Configuration Cleanup                                                  #
###############################################################################

if confirm "Clear Git global configuration?"; then
    log_info "Clearing Git global configuration..."
    git config --global --unset user.name 2>/dev/null || true
    git config --global --unset user.email 2>/dev/null || true
    git config --global --unset init.defaultBranch 2>/dev/null || true
    git config --global --unset pull.rebase 2>/dev/null || true
    git config --global --unset core.autocrlf 2>/dev/null || true
    git config --global --unset core.editor 2>/dev/null || true
    log_success "Git configuration cleared"
fi

###############################################################################
# SSH Key Removal                                                            #
###############################################################################

if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
    if confirm "Remove SSH key generated by setup? (id_ed25519)"; then
        log_warning "Removing SSH keys..."
        rm -f "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.pub"
        log_success "SSH keys removed"
    fi
fi

###############################################################################
# Directory Cleanup                                                          #
###############################################################################

if confirm "Remove directories created by setup? (~/Developer, ~/Desktop/Screenshots)"; then
    log_info "Removing created directories..."
    
    if [[ -d "$HOME/Developer" ]]; then
        if confirm "Remove ~/Developer? (This may contain your projects!)"; then
            rm -rf "$HOME/Developer"
            log_success "~/Developer removed"
        fi
    fi
    
    if [[ -d "$HOME/Desktop/Screenshots" ]]; then
        rm -rf "$HOME/Desktop/Screenshots"
        log_success "~/Desktop/Screenshots removed"
    fi
fi

###############################################################################
# macOS Preferences Restoration (Partial)                                   #
###############################################################################

if confirm "Reset some macOS preferences to defaults?"; then
    log_info "Resetting macOS preferences..."
    
    # Screenshot settings
    defaults write com.apple.screencapture type -string "png"
    defaults write com.apple.screencapture location -string "$HOME/Desktop"
    
    # Finder settings (reset to more conservative defaults)
    defaults write com.apple.finder AppleShowAllFiles -bool false
    defaults write com.apple.finder ShowPathbar -bool false
    defaults write com.apple.finder ShowStatusBar -bool false
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool false
    
    # Dock settings
    defaults write com.apple.dock tilesize -int 64
    defaults write com.apple.dock autohide -bool false
    defaults write com.apple.dock workspaces-auto-swoosh -bool true
    
    # Re-enable some automatic features
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true
    
    # Hide ~/Library again
    chflags hidden ~/Library 2>/dev/null || true
    
    # Restart affected applications
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    killall SystemUIServer 2>/dev/null || true
    
    log_success "Some macOS preferences reset"
    log_warning "Note: Not all preferences could be reset automatically"
fi

###############################################################################
# Final Cleanup                                                              #
###############################################################################

# Remove pyenv if it was installed by our script
if command_exists pyenv && confirm "Remove pyenv entirely?"; then
    log_info "Removing pyenv..."
    rm -rf "$HOME/.pyenv"
    log_success "pyenv removed"
fi

# Final message
echo
log_success "🎉 Restoration completed!"
echo
log_warning "Manual steps you may want to take:"
echo "  1. Restart your terminal to apply shell changes"
echo "  2. Review System Preferences for any remaining custom settings"
echo "  3. Check Applications folder for any remaining installed apps"
echo "  4. Review ~/Desktop and ~/Documents for any created files"
echo "  5. If you removed Homebrew, some CLI tools may no longer work"
echo
log_info "Your Mac should now be closer to its original state."
log_warning "Some system-level changes (like Command Line Tools) cannot be undone."
echo
