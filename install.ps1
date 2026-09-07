#Requires -Version 5.1
<#
.SYNOPSIS
  install.ps1 - one-shot deployment of this repo's configuration collection
  onto native Windows. PowerShell counterpart of install.sh (macOS/Linux).

.DESCRIPTION
  Sections (destinations default to the real Windows locations):
    nvim     -> %LOCALAPPDATA%\nvim      (directory junction, falls back to copy)
    zed      -> %APPDATA%\Zed            (settings.json, keymap.json)
    vscode   -> %APPDATA%\Code\User      (settings.json, snippets, extensions via 'code')
    trae     -> %APPDATA%\Trae\User      (settings.json, snippets)
    prettier -> %USERPROFILE%\.prettierrc + .prettierignore   (opt-in: -Prettier / -All)

  Everything already present is snapshotted to
  %USERPROFILE%\.config-backup\<timestamp>\ before being replaced, so the
  install is reversible. Every destination can be overridden with the
  matching environment variable (NVIM_DIR, ZED_DIR, VSCODE_USER_DIR,
  TRAE_USER_DIR, BACKUP_ROOT).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\install.ps1 -DryRun
.EXAMPLE
  .\install.ps1
.EXAMPLE
  .\install.ps1 -Zed -Trae
#>
[CmdletBinding()]
param(
    [switch]$All,          # include the home Prettier section
    [switch]$Nvim,
    [switch]$Zed,
    [switch]$Vscode,
    [switch]$Trae,
    [switch]$Prettier,
    [switch]$NoBackup,     # replace existing files without snapshots (risky)
    [switch]$NoExtensions, # skip the VS Code extension install step
    [switch]$DryRun        # preview what would change, write nothing
)

$ErrorActionPreference = 'Stop'

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserProfile = $env:USERPROFILE
if (-not $UserProfile) { throw 'USERPROFILE is not set - cannot locate user directories.' }

# Windows user directories (overridable via environment variables).
$appData  = if ($env:APPDATA)      { $env:APPDATA }      else { Join-Path $UserProfile 'AppData\Roaming' }
$localApp = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { Join-Path $UserProfile 'AppData\Local' }

$NvimDir       = if ($env:NVIM_DIR)        { $env:NVIM_DIR }        else { Join-Path $localApp 'nvim' }
$ZedDir        = if ($env:ZED_DIR)         { $env:ZED_DIR }         else { Join-Path $appData 'Zed' }
$VscodeUserDir = if ($env:VSCODE_USER_DIR) { $env:VSCODE_USER_DIR } else { Join-Path $appData 'Code\User' }
$TraeUserDir   = if ($env:TRAE_USER_DIR)   { $env:TRAE_USER_DIR }   else { Join-Path $appData 'Trae\User' }
$BackupRoot    = if ($env:BACKUP_ROOT)     { $env:BACKUP_ROOT }     else { Join-Path $UserProfile '.config-backup' }
$BackupDir     = Join-Path $BackupRoot (Get-Date -Format 'yyyyMMdd-HHmmss')

# --- section selection (default: nvim, zed, vscode, trae) ---------------
$Sections = @()
if ($All -or $Nvim)     { $Sections += 'nvim' }
if ($All -or $Zed)      { $Sections += 'zed' }
if ($All -or $Vscode)   { $Sections += 'vscode' }
if ($All -or $Trae)     { $Sections += 'trae' }
if ($All -or $Prettier) { $Sections += 'prettier' }
if ($Sections.Count -eq 0) { $Sections = @('nvim', 'zed', 'vscode', 'trae') }

function Write-Log   { param([string]$Msg) Write-Host "==> $Msg" -ForegroundColor Cyan }
function Write-Ok    { param([string]$Msg) Write-Host "  + $Msg" -ForegroundColor Green }
function Write-WarnM { param([string]$Msg) Write-Host "  ! $Msg" -ForegroundColor Yellow }

function Backup-Existing {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $rel = if ($Path.StartsWith($UserProfile, [System.StringComparison]::OrdinalIgnoreCase)) {
        $Path.Substring($UserProfile.Length).TrimStart('\')
    } else {
        Split-Path -Leaf $Path
    }
    $dst = Join-Path $BackupDir $rel
    if ($DryRun) { Write-Ok "would back up $Path -> $dst"; return }
    if (-not $NoBackup) {
        New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
        Copy-Item -LiteralPath $Path -Destination $dst -Recurse -Force
        Write-Ok "backed up $Path -> $dst"
    }
}

function Install-File {
    param([string]$Src, [string]$Dst)
    Backup-Existing $Dst
    if ($DryRun) { Write-Ok "would copy $Src -> $Dst"; return }
    New-Item -ItemType Directory -Force -Path (Split-Path $Dst) | Out-Null
    Copy-Item -LiteralPath $Src -Destination $Dst -Force
    Write-Ok "installed $Dst"
}

function Install-Dir {
    param([string]$Src, [string]$Dst)
    if (Test-Path -LiteralPath $Dst) {
        $item = Get-Item -LiteralPath $Dst -Force
        $isRealDir = $item.PSIsContainer -and -not $item.LinkType
        if ($isRealDir -and $NoBackup) {
            throw "refusing to replace existing directory $Dst without a backup (drop -NoBackup)"
        }
        Backup-Existing $Dst
        if ($DryRun) { Write-Ok "would replace $Dst with $Src"; return }
        Remove-Item -LiteralPath $Dst -Recurse -Force
    } elseif ($DryRun) {
        Write-Ok "would install $Src -> $Dst"
        return
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $Dst) | Out-Null
    # Prefer a directory junction (no admin rights needed) so the repo stays
    # the source of truth; fall back to a full copy where unsupported.
    try {
        New-Item -ItemType Junction -Path $Dst -Target $Src | Out-Null
        # Some non-Windows PowerShell builds accept Junction but create no
        # filesystem entry. Verify the result before claiming success.
        if (-not (Test-Path -LiteralPath $Dst)) {
            throw 'junction was not created'
        }
        Write-Ok "linked $Dst -> $Src"
    } catch {
        if (Test-Path -LiteralPath $Dst) {
            Remove-Item -LiteralPath $Dst -Recurse -Force -ErrorAction SilentlyContinue
        }
        Copy-Item -LiteralPath $Src -Destination $Dst -Recurse
        Write-Ok "installed $Dst (copied; junction unsupported: $($_.Exception.Message))"
    }
}

function Install-VscodeExtensions {
    if ($NoExtensions) { return }
    $listFile = Join-Path $RepoDir 'vscode\plugins.json'
    if (-not (Test-Path -LiteralPath $listFile)) { Write-WarnM "missing $listFile"; return }
    $exts = @((Get-Content -Raw -LiteralPath $listFile | ConvertFrom-Json).extensions)
    if ($exts.Count -eq 0) { return }
    if ($DryRun) { Write-Ok "would install $($exts.Count) extensions via 'code'"; return }
    $code = Get-Command code -ErrorAction SilentlyContinue
    if (-not $code) {
        Write-WarnM "no 'code' CLI on PATH - skipped extension install (re-run after installing it)"
        return
    }
    foreach ($e in $exts) {
        Write-Host "  + code --install-extension $e"
        & code --install-extension $e
        if ($LASTEXITCODE -ne 0) { Write-WarnM "failed to install $e (exit $LASTEXITCODE)" }
    }
}

# --- main ---------------------------------------------------------------
Write-Log "Profile installer (repo: $RepoDir)"
if ($DryRun) { Write-WarnM 'dry run - nothing will be written' }

if ($Sections -contains 'nvim') {
    Write-Log "Neovim -> $NvimDir"
    Install-Dir (Join-Path $RepoDir 'nvim') $NvimDir
}

if ($Sections -contains 'zed') {
    Write-Log "Zed -> $ZedDir"
    Install-File (Join-Path $RepoDir 'zed\settings.json') (Join-Path $ZedDir 'settings.json')
    Install-File (Join-Path $RepoDir 'zed\keymap.json') (Join-Path $ZedDir 'keymap.json')
}

if ($Sections -contains 'vscode') {
    Write-Log "VS Code -> $VscodeUserDir"
    Install-File (Join-Path $RepoDir 'vscode\settings.json') (Join-Path $VscodeUserDir 'settings.json')
    Install-File (Join-Path $RepoDir 'snippets\vue.json') (Join-Path $VscodeUserDir 'snippets\vue.json')
    Install-File (Join-Path $RepoDir 'snippets\csl.json') (Join-Path $VscodeUserDir 'snippets\csl.json')
    Install-VscodeExtensions
    if (-not $DryRun) {
        Write-Host "       profiles: import vscode\profiles\*.code-profile via"
        Write-Host '       Command Palette -> "Profiles: Import Profile"'
    }
}

if ($Sections -contains 'trae') {
    Write-Log "Trae -> $TraeUserDir"
    Install-File (Join-Path $RepoDir 'trae\settings.json') (Join-Path $TraeUserDir 'settings.json')
    Install-File (Join-Path $RepoDir 'snippets\vue.json') (Join-Path $TraeUserDir 'snippets\vue.json')
    Install-File (Join-Path $RepoDir 'snippets\csl.json') (Join-Path $TraeUserDir 'snippets\csl.json')
}

if ($Sections -contains 'prettier') {
    Write-Log "Prettier home defaults -> $UserProfile"
    Install-File (Join-Path $RepoDir '.prettierrc') (Join-Path $UserProfile '.prettierrc')
    Install-File (Join-Path $RepoDir '.prettierignore') (Join-Path $UserProfile '.prettierignore')
}

Write-Host ''
Write-Log 'Done.'
if ($DryRun) {
    Write-WarnM 'dry run - nothing was written. Re-run without -DryRun to apply.'
} else {
    Write-Host '  - nvim: run `nvim` once - lazy.nvim bootstraps and installs all plugins'
    Write-Host '  - VS Code: import profiles via Command Palette -> "Profiles: Import Profile"'
    Write-Host '  - Restart Zed / VS Code / Trae so the new settings take effect'
    if (-not $NoBackup) { Write-Host "  - Previous files are kept under $BackupDir" }
}
