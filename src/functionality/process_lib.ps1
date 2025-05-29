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
    # Fetch all WMI process info just once
    $wmiProcesses = Get-WmiObject Win32_Process
    $wmiMap = @{}
    foreach ($w in $wmiProcesses) {
        $wmiMap[$w.ProcessId] = $w
    }

    # Get live process data
    $processes = Get-Process | Sort-Object -Property CPU -Descending

    foreach ($proc in $processes) {
        $wmi = $wmiMap[$proc.Id]
        $owner = if ($wmi) { Get-UserOfProcess $wmi } else { "N/A" }
        $path  = if ($wmi) { $wmi.ExecutablePath } else { $null }

        [PSCustomObject]@{
            Id         = $proc.Id
            Name       = $proc.ProcessName
            CPU        = [math]::Round($proc.CPU, 2)
            WorkingSet = [math]::Round($proc.WorkingSet64 / 1MB, 2)
            User       = $owner
            Path       = $path
        }
    }
}


function Get-ProcessInfoTable {
    Get-ProcessWithUser | Format-Table -AutoSize
}

function Get-ProcessInfoJson {
    Get-ProcessWithUser | ConvertTo-Json
}