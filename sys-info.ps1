param (
    [Parameter(Mandatory = $false)]
    [switch]$Help,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile,

    [Parameter(Mandatory = $false)]
    [switch]$Json
)

# In script scope (outside param)
$knownParams = @('Help', 'OutputFile', 'Json')
$passedParams = $PSCmdlet.MyInvocation.BoundParameters.Keys

foreach ($param in $passedParams) {
    if ($param -notin $knownParams) {
        Write-Output "Unknown parameter: -$param"
        exit 1
    }
}

function Get-UserOfProcess($proc) {
    $na_user = "N/A"
    try {
        $ownerInfo = $proc.GetOwner()
        if ($ownerInfo.ReturnValue -eq 0) {
            return "$($ownerInfo.Domain)\$($ownerInfo.User)"
        }
        else {
            return $na_user
        }
    }
    catch {
        return $na_user
    }
}

function Get-ProcessWithUser {
    # Get live process data
    $processes = Get-Process -IncludeUserName | Sort-Object -Property CPU -Descending

    # Create new object with necessary data only.
    # CPU - time passed since the process was created in seconds.
    # MEM - memory usage in megabytes
    foreach ($proc in $processes) {
        [PSCustomObject]@{
            Id         = $proc.Id
            Name       = $proc.ProcessName
            CPU        = [math]::Round($proc.CPU, 2)
            Mem = [math]::Round($proc.WorkingSet64 / 1MB, 2)
            User       = $proc.UserName
        }
    }
}


# Get processes and align in table.
function Get-ProcessInfoTable {
    Get-ProcessWithUser | Format-Table -Property `
        @{Label = "PId"; Expression = { "{0,-8}" -f $_.Id } },
        @{Label = "Name";  Expression = { $_.Name.PadRight(25) } },
        @{Label = "Mem";   Expression = { "{0,-8:N2}" -f $_.Mem } },
        @{Label = "CPU";   Expression = { "{0,-8:N2}" -f $_.CPU } },
        @{Label = "User";  Expression = { $_.User.PadRight(25) } } `
}

# Get processes in JSON format.
function Get-ProcessInfoJson {
    Get-ProcessWithUser | ConvertTo-Json
}

function Show-Help {
    @"
sys-info.ps1 [-Help] [-Verbose] [-Json] [-OutputFile <path>]

Options:
  -Help         Show this help message
  -OutputFile   Write results to the given file
  -Json         Output in JSON format
"@
}

function Main {
    if ($Help) {
        Show-Help
        exit 0
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
}

Main
