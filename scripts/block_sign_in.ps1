function Start-BlockingSignIn {
    try {
        # Check if the session is valid
        if (-not (Test-MgSession)) {
            Write-Host "Session is not valid. Please ensure you're connected." -ForegroundColor Red
            return
        }

        # Prompt for CSV file path
        $csvPath = Read-Host "Enter the path to the CSV file"
        
        # Check if provided CSV exists
        if (-not (Test-Path $csvPath)) {
            Write-Host "CSV file not found at path: $csvPath" -ForegroundColor Red
            return
        }

        # Create output directory if it doesn't exist
        $outputDir = Join-Path $PSScriptRoot ".." "output"
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir | Out-Null
        }

        # Create output file path with timestamp
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $outputPath = Join-Path $outputDir "block_signin_output_$timestamp.txt"

        # Import CSV
        $users = Import-Csv $csvPath
        $totalUsers = $users.Count
        $blockedCount = 0
        $failedCount = 0

        Write-Host "Starting to process $totalUsers users..." -ForegroundColor Yellow

        foreach ($user in $users) {
            try {
                # Get the user by UserPrincipalName
                $userDetails = Get-MgUser -Filter "UserPrincipalName eq '$($user.userPrincipalName)'"
    
                if ($userDetails) {
                    # Disable the user account
                    $updateParams = @{ AccountEnabled = $false }
                    Update-MgUser -UserId $userDetails.Id -BodyParameter $updateParams
                    Write-Host "Successfully blocked sign-in for: $($user.userPrincipalName)" -ForegroundColor Green
                    "Successfully blocked sign-in for: $($user.userPrincipalName)" | Out-File -FilePath $outputPath -Append
                    $blockedCount++
                } else {
                    $message = "User not found: $($user.userPrincipalName)"
                    Write-Host $message -ForegroundColor Red
                    $message | Out-File -FilePath $outputPath -Append
                    $failedCount++
                }
            } catch {
                $errorMsg = "Error blocking $($user.userPrincipalName): $($_.Exception.Message)"
                Write-Host $errorMsg -ForegroundColor Red
                $errorMsg | Out-File -FilePath $outputPath -Append
                $failedCount++
            }
        }

        # Print summary
        Write-Host "`nBlock Sign-in Summary:" -ForegroundColor Cyan
        Write-Host "Total Users Processed: $totalUsers" -ForegroundColor White
        Write-Host "Successfully Blocked: $blockedCount" -ForegroundColor Green
        Write-Host "Failed: $failedCount" -ForegroundColor Red
        Write-Host "Log file saved to: $outputPath" -ForegroundColor Yellow

    } catch {
        Write-Host "An error occurred during block sign-in process: $_" -ForegroundColor Red
    }
}
