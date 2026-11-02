# Dotfiles

Backups of the configuration currently used on the laptop. Files are copied into place rather than symlinked.

## Included

- `.zshrc`: shell configuration, PATH setup, aliases and uv environments.
- `.vimrc`: Vim configuration and plugins.
- `.gitconfig`: Git settings, Delta and GitHub CLI credential helpers.
- `.cli-tools-cheatsheet.md`: command-line reference.
- `btop.conf`: system-monitor settings.
- `ssh.config`: the include for Conductor-managed SSH configuration.
- `cursor-settings.json`: the current minimal Cursor preferences.
- `opencode.json.template` and `settings.json.template`: OpenCode and Zed templates, without actual credentials.

Cursor uses its default keybindings; no custom keybindings file is restored. Earlier settings and keybindings remain in Git history.

## Restore on a new machine

Install the referenced tools first, then clone into the canonical project location:

```sh
mkdir -p "$HOME/Developer"
git clone https://github.com/shayaansultan/dotfiles.git "$HOME/Developer/dotfiles"
cd "$HOME/Developer/dotfiles"

cp .zshrc .vimrc .gitconfig .cli-tools-cheatsheet.md "$HOME/"

install -d -m 700 "$HOME/.ssh"
install -m 600 ssh.config "$HOME/.ssh/config"

mkdir -p "$HOME/.config/btop"
cp btop.conf "$HOME/.config/btop/btop.conf"

mkdir -p "$HOME/Library/Application Support/Cursor/User"
cp cursor-settings.json "$HOME/Library/Application Support/Cursor/User/settings.json"

mkdir -p "$HOME/.config/opencode" "$HOME/.config/zed"
cp opencode.json.template "$HOME/.config/opencode/opencode.json"
cp settings.json.template "$HOME/.config/zed/settings.json"
```

Set up credentials locally after copying the templates. GitHub authentication uses the already configured GitHub CLI account. Conductor creates `~/.ssh/conductor_config`; this repository stores only the include, not generated hosts or private keys.

## Machine-specific shell settings

The shared `.zshrc` loads `~/.zshrc.local` when that file exists. Keep the laptop's Switchboard signing identity and any other machine-specific values there. The file is optional and ignored by Git. Create it locally with permissions `600` when needed; do not copy its values into this public repository.

## Update the backups

```sh
cd "$HOME/Developer/dotfiles"
cp "$HOME/.zshrc" "$HOME/.vimrc" "$HOME/.gitconfig" "$HOME/.cli-tools-cheatsheet.md" .
cp "$HOME/.config/btop/btop.conf" btop.conf
cp "$HOME/.ssh/config" ssh.config
cp "$HOME/Library/Application Support/Cursor/User/settings.json" cursor-settings.json

git diff --check
git diff
```

Review the diff before committing. Keep signing identities, private keys, tokens, generated SSH hosts, `.zshrc.local` and actual secret-bearing application configs local. Changes intended for sharing go into the tracked files; earlier versions remain recoverable from Git history.
