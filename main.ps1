. .\auth.ps1

function Show-Menu {
    Clear-Host
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "           Welcome to the Dashboard            " -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host
    Write-Host "1. Create users"
    Write-Host "2. Block sign-in"
    Write-Host "3. Create VPN users"
    Write-Host "Q. Exit"
    Write-Host
}

# Initialize session at startup
if (-not (Initialize-MgSession)) {
    Write-Host "Failed to initialize session. Exiting..." -ForegroundColor Red
    exit
}

# Main program loop
do {
    Show-Menu
    $choice = Read-Host "Please enter your choice"
    
    switch ($choice.Trim().ToUpper()) {
        "1" {
            Clear-Host
            Write-Host "Starting user creation process..." -ForegroundColor Yellow
            . "$PSScriptRoot\scripts\create_users.ps1"
            Start-UserCreation
            Write-Host "`nPress Enter to return to menu..." -ForegroundColor Green
            $null = Read-Host
        }
        "2" {
            Clear-Host
            Write-Host "Starting block sign-in process..." -ForegroundColor Yellow
            . "$PSScriptRoot\scripts\block_sign_in.ps1"
            Start-BlockingSignIn
            Write-Host "`nPress Enter to return to menu..." -ForegroundColor Green
            $null = Read-Host
        }
        "3" {
            Clear-Host
            Write-Host "Starting VPN user creation process..." -ForegroundColor Yellow
            . "$PSScriptRoot\scripts\vpn_user_creation.ps1"
            Start-VPNUserCreation
            Write-Host "`nPress Enter to return to menu..." -ForegroundColor Green
            $null = Read-Host
        }
        "4" {
            Clear-Host
            Write-Host "Starting bulk password reset process..." -ForegroundColor Yellow
            . "$PSScriptRoot\scripts\bulk_password_reset.ps1"
            Start-PasswordReset
            Write-Host "`nPress Enter to return to menu..." -ForegroundColor Green
            $null = Read-Host
        }
        "Q" {
            Write-Host "Exiting program..." -ForegroundColor Yellow
            Close-MgSession
            exit
        }
        default {
            Write-Host "`nInvalid choice. Press Enter to continue..." -ForegroundColor Red
            $null = Read-Host
        }
    }
} while ($true)