# 🤝 Contributing to macOS Developer Setup

First off, thanks for considering contributing to this project! 🎉 

This project thrives on community contributions - whether it's adding new tools, improving documentation, fixing bugs, or sharing your customizations.

## 🌟 Quick Ways to Contribute

### ⭐ **Star the Repository**
The easiest way to help! Stars help other developers discover the project.

### 🍴 **Fork and Customize**  
Create your own version and share it with the community in our [Show & Tell](https://github.com/yourusername/mac-setup/issues/new?template=show_and_tell.md).

### 💬 **Join Discussions**
- Share feedback in Issues
- Help answer questions from other users
- Suggest improvements and new features

## 🚀 Types of Contributions We Love

### 🛠️ **New Tools & Applications**
Know an amazing developer tool? Add it to the `Brewfile`!

**What we look for:**
- Genuinely useful for developers
- Actively maintained
- Available via Homebrew
- Not too niche (useful for most developers)

### ⚙️ **macOS Improvements**  
Found a great system tweak? Add it to `macos-defaults.sh`!

**Guidelines:**
- Developer-focused improvements
- Well-documented with comments
- Reversible (can be undone by restore script)

### 🐚 **Shell Enhancements**
Cool aliases, functions, or configurations for `.zshrc`!

### 📚 **Documentation**
- Improve README clarity
- Add usage examples  
- Fix typos and grammar
- Translate to other languages

### 🐛 **Bug Fixes**
Found something broken? We appreciate bug reports and fixes!

## 📋 Contribution Process

### 1. **Check Existing Issues**
Before creating new issues or PRs, check if someone else is already working on it.

### 2. **Fork the Repository**
```bash
# Fork on GitHub, then clone your fork
git clone https://github.com/YOUR-USERNAME/mac-setup.git
cd mac-setup
```

### 3. **Create a Branch**
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 4. **Make Your Changes**
- **Adding tools**: Edit `Brewfile`
- **System tweaks**: Edit `macos-defaults.sh`  
- **Shell improvements**: Edit `.zshrc`
- **Docs**: Edit `README.md` or create new docs

### 5. **Test Your Changes**
```bash
# Test the setup script
./setup.sh

# Test the restore script
./restore.sh
```

### 6. **Commit with Clear Messages**
```bash
git add .
git commit -m "Add: HTTPie for API testing in Brewfile"
# or
git commit -m "Fix: Correct path for zsh-autosuggestions"
# or  
git commit -m "Docs: Add troubleshooting section to README"
```

### 7. **Push and Create Pull Request**
```bash
git push origin feature/your-feature-name
```

Then create a PR on GitHub with:
- Clear description of what you changed
- Why the change is useful
- Any testing you performed

## 📝 Pull Request Guidelines

### ✅ **Good PRs Include:**
- **Clear title**: What does this PR do?
- **Description**: Why is this change useful?
- **Testing info**: How did you verify it works?
- **Screenshots**: For UI/visual changes

### 📋 **PR Checklist:**
- [ ] Code follows existing style/patterns
- [ ] Changes are documented (comments, README updates)
- [ ] Tested on a fresh macOS installation (if possible)
- [ ] No personal information hardcoded
- [ ] Backwards compatible (doesn't break existing setups)

## 🎯 Specific Contribution Ideas

### 🥇 **High Impact (Great First Issues)**
- Add missing developer tools to Brewfile
- Improve error handling in setup.sh
- Add more useful aliases to .zshrc
- Create setup variations (minimal, web-dev, data-science)

### 🚀 **Advanced Contributions**
- GUI setup tool for non-technical users
- Docker version for safe testing
- CI/CD pipeline for testing
- Support for other platforms (Linux, Windows)

### 📚 **Documentation**
- Video walkthrough/demo
- Troubleshooting guide
- Customization examples
- Team deployment guide

## 🎨 Code Style

### **Shell Scripts:**
- Use `#!/bin/bash` shebang
- Include `set -euo pipefail` for safety
- Comment extensively
- Use consistent logging functions
- Check for existing configs before modifying

### **Brewfile:**
- Group similar packages together
- Include comments for less obvious tools
- Maintain alphabetical order within groups
- Test that packages install correctly

### **Documentation:**
- Use clear, concise language
- Include code examples
- Use emojis sparingly but consistently
- Keep line length reasonable

## 🏆 Recognition

Contributors get:
- **Recognition** in README
- **Shoutouts** on social media (if desired)
- **Early access** to new features
- **Influence** on project direction
- **Good karma** from helping developers worldwide! 

## 🚨 Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct.

**TL;DR: Be respectful, inclusive, and helpful. We're all here to build something awesome together!**

## 💬 Questions?

- **General questions**: Open an [issue](https://github.com/yourusername/mac-setup/issues/new)
- **Quick questions**: Comment on relevant issues
- **Ideas/discussions**: Use [Discussions](https://github.com/yourusername/mac-setup/discussions) (if enabled)

---

**Thanks for making the macOS developer experience better for everyone! 🚀**

*Remember: Every contribution, no matter how small, makes a difference. Welcome to the community!*
