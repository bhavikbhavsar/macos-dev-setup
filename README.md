# 🍎 Mac Setup Script

Automate your initial Mac setup using:

- Homebrew
- CLI tools
- Python dev environment
- macOS preferences
- Zsh shell enhancements

## 🛠️ Usage

```bash
git clone https://github.com/yourusername/mac-setup.git
cd mac-setup

# Edit setup.sh to customize Git configuration (optional)
# DEFAULT_GIT_NAME="Your Name"
# DEFAULT_GIT_EMAIL="your.email@example.com"

chmod +x setup.sh
./setup.sh
```

## 📋 What's Included

### 🍺 Homebrew Packages
- Essential CLI tools: `git`, `gh`, `tmux`, `fzf`, `ripgrep`, `fd`, `bat`, `jq`, `httpie`, `tree`, `eza`
- Development tools: `node`, `python@3.11`, `pyenv`, `pipx`, `uv`, `go`, `rust`, `docker`
- Applications: VS Code, iTerm2, Sublime Text, CleanShot, Notion, Raycast, Bitwarden, Chrome, Slack, Discord, Figma, Zoom, OBS
- Fonts: Hack Nerd Font, Meslo LG Nerd Font

### 🐍 Python Environment
- Python 3.12.5 via pyenv
- Poetry for dependency management
- Pre-commit for code quality

### 🌟 Zsh Enhancements
- Starship prompt
- Auto-suggestions
- Syntax highlighting
- Custom aliases and functions

### ⚙️ macOS Preferences
- Developer-friendly defaults
- Finder enhancements
- Dock optimizations
- Screenshot preferences
- Keyboard/trackpad improvements

## 📁 Project Structure

```
mac-setup/
├── Brewfile           # Homebrew packages and applications
├── macos-defaults.sh  # macOS system preferences configuration
├── setup.sh          # Main setup orchestration script
├── restore.sh         # Restoration/revert script
├── .zshrc            # Zsh shell configuration
└── README.md         # This file
```

## 🔄 Restoration

If you want to revert the changes made by the setup script:

```bash
chmod +x restore.sh
./restore.sh
```

The restore script will:
- Remove Homebrew packages from Brewfile
- Uninstall Oh My Zsh
- Restore backed up .zshrc files  
- Remove Python environments
- Clear Git configuration
- Reset some macOS preferences
- Clean up created directories (optional)

**Note**: Some changes cannot be automatically reverted (like Xcode Command Line Tools) and will require manual cleanup.

## 🔧 Customization

### Git Configuration
Edit the default values in `setup.sh`:
```bash
DEFAULT_GIT_NAME="Your Name"
DEFAULT_GIT_EMAIL="your.email@example.com"
```

### Adding Packages
Edit `Brewfile` to add more packages:
```ruby
brew "package-name"
cask "application-name"
```

### macOS Settings
Modify `macos-defaults.sh` to customize system preferences.

## ✨ Features

- **Idempotent**: Safe to run multiple times - won't duplicate configurations or reinstall existing packages
- **Non-destructive**: Backs up existing configurations before making changes
- **Intelligent**: Checks for existing installations and configurations

## 🚨 Requirements

- macOS (tested on recent versions)  
- Internet connection
- Administrator access

## 📝 Post-Setup

1. Restart your terminal: `source ~/.zshrc`
2. Add SSH key to GitHub (if generated)
3. Verify Python: `python --version` and `poetry --version`
4. Restart Mac for all system preferences to take effect

## 🤝 Contributing

Feel free to fork and customize for your needs. Pull requests welcome!

## 📄 License

MIT License - see LICENSE file for details.