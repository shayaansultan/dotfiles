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

Install Homebrew, Oh My Zsh and its `zsh-autosuggestions` plugin. The current shell setup uses `thefuck`, `zoxide`, `fzf` and nvm; its aliases and Git settings use uv, `bat`, `delta`, `gh` and `lazygit`. Install the tools you intend to use. LM Studio and Vite+ paths are optional.

On an Apple Silicon Mac, make sure `~/.zprofile` contains Homebrew's login-shell setup before opening a shell with the restored `.zshrc`:

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

This is already present on the current laptop. On a new machine, add it once and start a new login shell. Then clone into the canonical project location:

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

Set up credentials locally after copying the templates. On a new machine, run `gh auth login` after installing `gh` and complete sign-in yourself; the credential helper then uses that account. Conductor creates `~/.ssh/conductor_config`; this repository stores only the include, not generated hosts or private keys.

## Restore on Windows

`windows/` holds the Windows counterparts. Projects live in `Desktop\Developer` on Windows.

- `windows/profile.ps1`: the shell setup from `.zshrc` for PowerShell 5.1 and 7, with zoxide, fnm for Node, fzf key bindings through PSFzf, and the same aliases.
- `windows/bootstrap.ps1`: installs the CLI tools with scoop, applies the `.gitconfig` settings, adds `~\.local\bin` (launchers such as `agentfiles.cmd`) and `~\.bun\bin` (`bun add -g` tools such as `codex`) to the user PATH, tells Claude Code where Scoop's Git Bash is (`CLAUDE_CODE_GIT_BASH_PATH`, needed for `.sh` hooks), points both PowerShell profiles at `windows/profile.ps1`, and copies the cheatsheet and `.vimrc`. It needs no admin rights and is safe to rerun after a pull.

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
irm get.scoop.sh | iex; scoop install git
git clone https://github.com/shayaansultan/dotfiles.git "$HOME\Desktop\Developer\dotfiles"
& "$HOME\Desktop\Developer\dotfiles\windows\bootstrap.ps1"
gh auth login; gh auth setup-git
```

Git on Windows uses LF line endings (`core.autocrlf=false`), because scoop's Git converts to CRLF by default and that breaks formatter checks in the repositories. The `.gitconfig` copy is applied with `git config`, so the `gh` credential helper that `gh auth setup-git` writes stays in place.

Machine-specific PowerShell settings go in `~\.profile.local.ps1`, which the profile loads when it exists and Git never sees.

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
