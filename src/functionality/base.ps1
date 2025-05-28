
#Get-ProcessWithUser | ConvertTo-Json

function Show-Help {
    @"
MyScript.ps1 [-Help] [-Verbose] [-OutputFile <path>]

Options:
  -Help         Show this help message
  -Verbose      Enable verbose output
  -OutputFile   Write results to the given file
"@ | Write-Host
    exit 0
}

function Print-ProcessTableInfo {
    Get-ProcessWithUser | Format-Table -AutoSize
}

function Main {
    if ($Help) {
        Show-Help
    }

    if ($Verbose) {
        Write-Host "Verbose mode is ON"
    }

    Print-ProcessTableInfo

    if ($OutputFile) {
        $output | Out-File -FilePath $OutputFile -Encoding UTF8
        if ($Verbose) { Write-Host "Output written to $OutputFile" }
    } else {
        Write-Host $output
    }
}

Main
