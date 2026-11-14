# Shared PowerShell profile: the Windows counterpart of .zshrc.
# Each machine's $PROFILE dot-sources this file from the dotfiles checkout
# (see windows/bootstrap.ps1), so a `git pull` updates every Windows machine.
# Works in Windows PowerShell 5.1 and PowerShell 7. Keep it ASCII-only.

$env:DEV = Join-Path $HOME 'Desktop\Developer'

# History-based inline suggestions (the zsh-autosuggestions equivalent).
if (Get-Module -ListAvailable PSReadLine) {
    try { Set-PSReadLineOption -PredictionSource History } catch {}
}

# zoxide: `z dirname`, `zi`.
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# fnm: Node version manager (the nvm equivalent); switches on cd into a repo with .nvmrc.
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# fzf: Ctrl+R history search and Ctrl+T file search, through the PSFzf module.
if (Get-Module -ListAvailable PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# Modern tool aliases.
Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue
function cat { bat -p @args }
function cheat { bat (Join-Path $HOME '.cli-tools-cheatsheet.md') }
function fzp { fzf --preview 'bat --color=always {}' }
Set-Alias lg lazygit
function op { opencode @args }
function ccp { claude --dangerously-skip-permissions --effort high @args }
function dev { Set-Location $env:DEV }

# Python (uv).
function env_new { uv venv @args }
function env_act { . .\.venv\Scripts\Activate.ps1 }

# Git.
function undo { git reset HEAD~ }
function recents { git branch --sort=-committerdate | Select-Object -First 20 }

# Optional machine-specific settings. This file stays outside Git.
$localProfile = Join-Path $HOME '.profile.local.ps1'
if (Test-Path $localProfile) { . $localProfile }
