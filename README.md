# 🏠 Dotfiles

My personal configuration files - a simple backup for when I get a new machine or need to restore settings.

## 📦 What's Included

- `.zshrc` - Shell configuration (Oh My Zsh, aliases, modern CLI tools)
- `.vimrc` - Vim editor configuration with plugins
- `.gitconfig` - Git settings with Delta for pretty diffs
- `.cli-tools-cheatsheet.md` - Quick reference for modern CLI tools
- `btop.conf` - System monitor configuration
- `opencode.json.template` - OpenCode editor settings (template)
- `settings.json.template` - Zed editor settings (template)
- `ssh.config` - SSH configuration

## 🚀 Using These Configs

### On a new machine:

```bash
# Clone the repo
git clone https://github.com/shayaansultan/dotfiles.git
cd dotfiles

# Copy configs to home directory
cp .zshrc ~/
cp .vimrc ~/
cp .gitconfig ~/
cp .cli-tools-cheatsheet.md ~/
cp ssh.config ~/.ssh/config

# Copy btop config
mkdir -p ~/.config/btop
cp btop.conf ~/.config/btop/

# For configs with API keys, use templates
mkdir -p ~/.config/opencode ~/.config/zed
cp opencode.json.template ~/.config/opencode/opencode.json
cp settings.json.template ~/.config/zed/settings.json

# Then edit and add your actual API keys:
vim ~/.config/opencode/opencode.json
vim ~/.config/zed/settings.json
```

## 🔐 Security Note

- Files with `.template` suffix need your API keys added after copying
- Actual config files with secrets are gitignored and never committed
- Your API keys stay local only

## 🛠️ Tools Referenced

Modern CLI tools configured in these dotfiles:

- **Shell**: zsh with Oh My Zsh
- **Navigation**: `eza` (ls), `fd` (find), `zoxide` (smart cd)
- **Search**: `rg` (grep), `fzf` (fuzzy finder)
- **Git**: `lazygit`, `delta`
- **Viewers**: `bat` (cat), `btop` (system monitor)
- **Editor**: vim with NERDTree, fzf, ALE

## 📝 Updating

When you update your configs locally:

```bash
cd ~/Desktop/dotfiles
cp ~/.zshrc .
cp ~/.vimrc .
cp ~/.gitconfig .
cp ~/.config/btop/btop.conf .
cp ~/.ssh/config ssh.config

git add -u
git commit -m "Update configs"
git push
```

---

**Simple backup approach - no fancy symlinks, just copy paste when needed!**
