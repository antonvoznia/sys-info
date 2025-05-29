function Show-Help {
    @"
sys-info.ps1 [-Help] [-Verbose] [-Json] [-OutputFile <path>]

Options:
  -Help         Show this help message
  -OutputFile   Write results to the given file
  -Json         Output in JSON format
"@ | Write-Host
    exit 0
}

function Main {
    if ($Help) {
        Show-Help
    }

    if ($Verbose) {
        Write-Host "Verbose mode is ON"
    }

    if ($Json) {
        $output = Get-ProcessInfoJson
    } else {
        $output = Get-ProcessInfoTable
    }

    Write-Output $output

    if (($OutputFile) -and ($output)) {
        Out-File -FilePath $OutputFile -InputObject $output -Encoding ascii
    }

    exit 0

    if ($OutputFile) {
        $output | Out-File -FilePath $OutputFile -Encoding UTF8
        if ($Verbose) { Write-Host "Output written to $OutputFile" }
    } else {
        Write-Host $output
    }
}

Main
