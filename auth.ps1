function Initialize-MgSession {
    try {
        if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
            throw "Microsoft.Graph module not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
        }

        $requiredScopes = @("User.ReadWrite.All", "Directory.ReadWrite.All")
        $currentContext = Get-MgContext

        if ($currentContext) {
            $missingScopes = $requiredScopes | Where-Object { $currentContext.Scopes -notcontains $_ }
            if ($missingScopes) {
                Disconnect-MgGraph
            } else {
                $script:authSession = $currentContext
                return $true
            }
        }

        Connect-MgGraph -Scopes $requiredScopes -ErrorAction Stop
        $script:authSession = Get-MgContext
        return $true
    }
    catch {
        Write-Host "Error during initialization: $_" -ForegroundColor Red
        return $false
    }
}

function Test-MgSession {
    try {
        if (-not $script:authSession) { 
            return Initialize-MgSession 
        }
        Get-MgUser -Top 1 -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        Write-Host "Error during session test: $_" -ForegroundColor Red
        return Initialize-MgSession
    }
}

function Close-MgSession {
    try {
        if (Get-MgContext) {
            Disconnect-MgGraph
            $script:authSession = $null
            Write-Host "Session disconnected successfully." -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Error during session close: $_" -ForegroundColor Red
    }
}
