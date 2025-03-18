# Terminal Todo Tracker (ttt) - PowerShell Wrapper
# Usage: .\ttt.ps1 [command]

$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Check if WSL is available
function Test-WSL {
    try {
        $wsl = Get-Command wsl -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Check if Git Bash is installed
function Test-GitBash {
    $gitBashPaths = @(
        "C:\Program Files\Git\bin\bash.exe",
        "C:\Program Files (x86)\Git\bin\bash.exe"
    )

    foreach ($path in $gitBashPaths) {
        if (Test-Path $path) {
            return $path
        }
    }

    # Check if bash is in PATH
    try {
        $bash = Get-Command bash -ErrorAction Stop
        return $bash.Source
    }
    catch {
        return $null
    }
}

# Try WSL first
if (Test-WSL) {
    Write-Host "Using Windows Subsystem for Linux (WSL)..."
    $argString = $args -join " "
    wsl -e bash -c "cd '$ScriptPath' && ./ttt $argString"
}
# Then try Git Bash
elseif ($bashPath = Test-GitBash) {
    Write-Host "Using Git Bash at $bashPath..."
    $argString = $args -join " "
    & $bashPath "$ScriptPath\ttt" $argString
}
else {
    Write-Host "ERROR: Could not find bash.exe or WSL." -ForegroundColor Red
    Write-Host "Please install Git for Windows or Windows Subsystem for Linux (WSL)." -ForegroundColor Red
    Write-Host "See README.md for more information." -ForegroundColor Red
    exit 1
} 