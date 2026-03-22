# =============================================
# Dotfiles Installation Script - Windows (PowerShell)
# =============================================

$ErrorActionPreference = "Stop"

# Colors
function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Cyan }
function Write-Success { Write-Host "[SUCCESS] $args" -ForegroundColor Green }
function Write-Warning { Write-Host "[WARNING] $args" -ForegroundColor Yellow }
function Write-Error-Custom { Write-Host "[ERROR] $args" -ForegroundColor Red }

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DotfilesDir = $ScriptDir

# Detect if running in WSL
function Test-WSL {
    return $env:WSL_DISTRO_NAME -ne $null
}

# Create backup
function Backup-Config {
    param([string]$Path)
    
    if (Test-Path $Path) {
        $backupName = "$Path.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Info "Backing up $Path to $backupName"
        Move-Item -Path $Path -Destination $backupName -Force
    }
}

# Create symlink (requires admin or developer mode)
function Create-Symlink {
    param(
        [string]$Source,
        [string]$Target
    )
    
    Backup-Config -Path $Target
    
    Write-Info "Creating symlink: $Target -> $Source"
    
    # Create directory if not exists
    $targetDir = Split-Path -Parent $Target
    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    # Remove existing file/link
    if (Test-Path $Target) {
        Remove-Item -Path $Target -Force
    }
    
    # Create symlink
    cmd /c "mklink `"$Target`" `"$Source`"" | Out-Null
    
    Write-Success "Created symlink: $Target"
}

# Install WezTerm configuration
function Install-WezTerm {
    Write-Info "Installing WezTerm configuration..."
    
    # Check if WezTerm is installed
    $weztermPath = (Get-Command wezterm -ErrorAction SilentlyContinue).Source
    
    if (!$weztermPath) {
        Write-Warning "WezTerm is not installed."
        Write-Info "To install WezTerm, visit: https://wezfurlong.org/wezterm/install/windows.html"
        Write-Warning "Skipping WezTerm configuration"
        return
    }
    
    # WezTerm config location on Windows
    $configDir = "$env:USERPROFILE\.config\wezterm"
    $configPath = "$configDir\wezterm.lua"
    
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    # Copy config file
    Copy-Item -Path "$DotfilesDir\wezterm\wezterm.lua" -Destination $configPath -Force
    
    Write-Success "WezTerm configuration installed to $configPath"
}

# Install Oh My Posh configuration
function Install-OhMyPosh {
    Write-Info "Installing Oh My Posh configuration..."
    
    # Check if Oh My Posh is installed
    $poshCommand = Get-Command oh-my-posh -ErrorAction SilentlyContinue
    
    if (!$poshCommand) {
        Write-Warning "Oh My Posh is not installed."
        Write-Info "Installing Oh My Posh..."
        
        # Install using winget
        winget install --id JanDeDobbeleer.OhMyPosh -e
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error-Custom "Failed to install Oh My Posh. Please install manually."
            return
        }
    }
    
    # Create themes directory
    $themesDir = "$env:USERPROFILE\.poshthemes"
    if (!(Test-Path $themesDir)) {
        New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
    }
    
    # Copy theme files
    Write-Info "Copying Oh My Posh themes..."
    Copy-Item -Path "$DotfilesDir\oh-my-posh\*.omp.json" -Destination $themesDir -Force
    
    # Setup PowerShell profile
    Setup-PowerShellProfile
    
    Write-Success "Oh My Posh configuration installed"
}

# Setup PowerShell profile
function Setup-PowerShellProfile {
    Write-Info "Setting up PowerShell profile..."
    
    $profilePath = $PROFILE.CurrentUserAllHosts
    $poshConfig = "$env:USERPROFILE\.poshthemes\posh-wsl.omp.json"
    
    # Create profile if not exists
    if (!(Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
    }
    
    # Check if Oh My Posh is already configured
    $profileContent = Get-Content $profilePath -Raw
    
    if ($profileContent -notlike "*oh-my-posh*") {
        Add-Content -Path $profilePath -Value "`n# Oh My Posh`n"
        Add-Content -Path $profilePath -Value "oh-my-posh init pwsh --config $poshConfig | Invoke-Expression`n"
        Write-Success "Added Oh My Posh to PowerShell profile"
    } else {
        Write-Info "Oh My Posh already configured in PowerShell profile"
    }
}

# Install Nerd Fonts
function Install-NerdFonts {
    Write-Info "Installing JetBrains Mono Nerd Font..."
    
    # Check if font is already installed
    $fontName = "JetBrainsMono Nerd Font"
    $installedFonts = Get-Font | Where-Object { $_.Name -like "*JetBrainsMono*" }
    
    if ($installedFonts) {
        Write-Info "JetBrains Mono Nerd Font is already installed"
        return
    }
    
    # Download and install font
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    $fontZip = "$env:TEMP\JetBrainsMono.zip"
    $fontDir = "$env:TEMP\JetBrainsMono"
    
    Write-Info "Downloading font..."
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip
    
    Write-Info "Extracting font..."
    Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force
    
    Write-Info "Installing fonts..."
    $fontFiles = Get-ChildItem -Path "$fontDir\*.ttf"
    foreach ($fontFile in $fontFiles) {
        $nonAdminDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
        if (!(Test-Path $nonAdminDir)) {
            New-Item -ItemType Directory -Path $nonAdminDir -Force | Out-Null
        }
        
        Copy-Item -Path $fontFile.FullName -Destination $nonAdminDir -Force
        
        # Register font
        $fontName = $fontFile.Name
        Add-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $fontName -Value $fontFile.Name -Force
    }
    
    Write-Success "JetBrains Mono Nerd Font installed"
}

# Main installation function
function Main {
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "  Dotfiles Installation Script (Windows)" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    
    if (Test-WSL) {
        Write-Info "Running in WSL: $($env:WSL_DISTRO_NAME)"
    } else {
        Write-Info "Running in native Windows"
    }
    
    Write-Host ""
    Write-Host "Select what to install:" -ForegroundColor White
    Write-Host "  1. WezTerm configuration" -ForegroundColor White
    Write-Host "  2. Oh My Posh configuration" -ForegroundColor White
    Write-Host "  3. Nerd Fonts" -ForegroundColor White
    Write-Host "  4. All of the above" -ForegroundColor White
    Write-Host "  5. Exit" -ForegroundColor White
    Write-Host ""
    
    $choice = Read-Host "Enter your choice (1-5)"
    
    switch ($choice) {
        "1" { Install-WezTerm }
        "2" { Install-OhMyPosh }
        "3" { Install-NerdFonts }
        "4" { 
            Install-WezTerm
            Install-OhMyPosh
            Install-NerdFonts
        }
        "5" { 
            Write-Info "Exiting..."
            exit 0
        }
        default { 
            Write-Error-Custom "Invalid choice"
            exit 1
        }
    }
    
    Write-Host ""
    Write-Success "Installation complete!"
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "  Next Steps:" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "  - For WezTerm: Restart WezTerm"
    Write-Host "  - For Oh My Posh: Restart PowerShell or run: Reload-OhMyPosh"
    Write-Host "=============================================" -ForegroundColor Cyan
}

# Run main function
Main
