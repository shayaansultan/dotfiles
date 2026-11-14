# Set up a Windows machine from this dotfiles checkout. Idempotent: rerun after
# a pull to pick up new tools. Needs no admin rights (scoop installs per user).
#
#   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#   irm get.scoop.sh | iex; scoop install git
#   git clone https://github.com/shayaansultan/dotfiles.git "$HOME\Desktop\Developer\dotfiles"
#   & "$HOME\Desktop\Developer\dotfiles\windows\bootstrap.ps1"
#
# Then sign in yourself: `gh auth login`, then `gh auth setup-git`.

$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent

# 1. CLI tools: the Windows equivalents of the Homebrew tools .zshrc uses.
$tools = @(
    'gh', 'bun', 'uv', 'fnm', 'ripgrep', 'fd', 'fzf', 'bat', 'delta',
    'zoxide', 'lazygit', 'jq', 'tealdeer', 'vim', 'pwsh'
)
if (-not ((scoop bucket list).Name -contains 'extras')) { scoop bucket add extras }  # lazygit
$installed = (scoop list 6>$null | ForEach-Object { $_.Name })
foreach ($tool in $tools + 'lazygit') {
    if ($installed -contains $tool) { continue }
    if ($tool -eq 'gh' -and (Get-Command gh -ErrorAction SilentlyContinue)) { continue }  # winget install
    scoop install $tool
}

# 2. Git: the shared .gitconfig minus the macOS credential helper, plus LF line
# endings (scoop's Git defaults to autocrlf=true, which breaks oxfmt checks).
$git = [ordered]@{
    'user.name' = 'Shayaan Sultan'; 'user.email' = 'sultan.shayaan@gmail.com'
    'core.autocrlf' = 'false'; 'core.eol' = 'lf'; 'core.pager' = 'delta'
    'interactive.diffFilter' = 'delta --color-only'
    'delta.navigate' = 'true'; 'delta.line-numbers' = 'true'
    'delta.side-by-side' = 'true'; 'delta.dark' = 'true'
    'merge.conflictstyle' = 'diff3'; 'diff.colorMoved' = 'default'
    'init.defaultBranch' = 'main'
    'alias.co' = 'checkout'; 'alias.wl' = 'worktree list'
    'alias.wr' = 'worktree remove --force'
    'alias.get' = '!git fetch --all --prune && git pull'
    'alias.f' = '!git fetch --all --prune && git pull'
    'alias.p' = 'push'; 'alias.cm' = 'commit -m'
}
foreach ($key in $git.Keys) { git config --global $key $git[$key] }

# 3. Shell: put ~\.local\bin (agentfiles.cmd and other launchers) on the user
# PATH, and point both PowerShell editions' profiles at windows/profile.ps1.
$localBin = Join-Path $HOME '.local\bin'
New-Item -ItemType Directory -Force $localBin | Out-Null
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $localBin) {
    [Environment]::SetEnvironmentVariable('Path', "$userPath;$localBin", 'User')
}
$shared = Join-Path $PSScriptRoot 'profile.ps1'
$docs = [Environment]::GetFolderPath('MyDocuments')
$stub = ". '$shared'"
foreach ($dir in 'WindowsPowerShell', 'PowerShell') {
    $file = Join-Path $docs "$dir\Microsoft.PowerShell_profile.ps1"
    New-Item -ItemType Directory -Force (Split-Path $file) | Out-Null
    if ((Test-Path $file) -and ((Get-Content $file -Raw) -match [regex]::Escape($shared))) { continue }
    Add-Content -Path $file -Value $stub -Encoding utf8
}
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    pwsh -NoProfile -Command "if (-not (Get-Module -ListAvailable PSFzf)) { Install-PSResource PSFzf -Repository PSGallery -Scope CurrentUser -TrustRepository }"
}

# 4. Files that are shared as-is.
Copy-Item (Join-Path $repo '.cli-tools-cheatsheet.md') $HOME -Force
Copy-Item (Join-Path $repo '.vimrc') (Join-Path $HOME '_vimrc') -Force
New-Item -ItemType Directory -Force (Join-Path $HOME '.vim\undodir') | Out-Null
$plug = Join-Path $HOME 'vimfiles\autoload\plug.vim'
if (-not (Test-Path $plug)) {
    New-Item -ItemType Directory -Force (Split-Path $plug) | Out-Null
    Invoke-WebRequest 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' -OutFile $plug
}

Write-Host 'Done. Open a new terminal. Run `gh auth status` to check the GitHub sign-in.'
