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
    $processes = Get-WmiObject Win32_Process
    foreach ($proc in $processes) {
        $owner = Get-UserOfProcess $proc
        [PSCustomObject]@{
            Id         = $proc.ProcessId
            Name       = $proc.Name
            CPU        = $proc.CPU
            WorkingSet = $proc.WorkingSetSize
            User       = $owner
            Path       = $proc.ExecutablePath
        }
    }
}