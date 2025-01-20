. .\auth.ps1

function Show-Menu {
    Clear-Host
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "           Welcome to the Dashboard            " -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host
    Write-Host "1. Block sign-in"
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
            Write-Host "Starting block sign-in process..." -ForegroundColor Yellow
            . "$PSScriptRoot\scripts\block_sign_in.ps1"
            Start-BlockingSignIn
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