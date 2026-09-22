$ErrorActionPreference = "Stop"

$repo = Split-Path $PSScriptRoot -Parent | Split-Path -Parent
$homeDir = $HOME
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$files = @{
    "common\stow\git\.config\git\config" =
        "$homeDir\.config\git\config"

    "common\stow\herdr\.config\herdr\config.toml" =
        "$homeDir\.config\herdr\config.toml"

    "windows\starship\starship.toml" =
        "$homeDir\.config\starship.toml"

    "windows\powershell\Microsoft.PowerShell_profile.ps1" =
        "$homeDir\.config\powershell\Microsoft.PowerShell_profile.ps1"
}

foreach ($entry in $files.GetEnumerator()) {
    $source = Join-Path $repo $entry.Key
    $target = $entry.Value

    if (-not (Test-Path $source)) {
        Write-Warning "Missing source: $source"
        continue
    }

    $parent = Split-Path $target
    New-Item -ItemType Directory -Force $parent | Out-Null

    if (Test-Path $target) {
        $backup = "$target.bak-$timestamp"
        Move-Item -LiteralPath $target -Destination $backup
        Write-Host "Backed up: $target"
    }

    Copy-Item -LiteralPath $source -Destination $target
    Write-Host "Installed: $target"
}

