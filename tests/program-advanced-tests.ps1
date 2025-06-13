$ScriptName = "sys-info.ps1"
$ScriptPath = "$PSScriptRoot\..\$ScriptName"
$FailConst = 1
$PassConst = 0

$TestResult = $PassConst
# Evaluate Test and print results to terminal
function EvalTest($testName, $condition) {
    if ($condition) {
        Write-Host "[PASS] $testName" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $testName" -ForegroundColor Red
        $TestResult = $FailConst
    }
}

# Auxiliary functions for testing
function Get-ProcessTable {
    return & "$ScriptPath"
}

function Get-ProcessJson {
    return & "$ScriptPath" -Json
}

function Write-TableToFile {
    return & "$ScriptPath" -OutputFule out.txt
}

# Tests implementation

$CMDFullName = "cmd.exe"
$CMDName = "cmd"

$PWSHFullName = "powershell.exe"
$PWSHName = "powershell"

function Start-Proc($Proc) {
    $app = Start-Process $Proc -PassThru
    Write-Output "$Proc started with PID $app.Id"

    return $app
}

function Test-NewProcessRun {
    $cmd = Start-Proc $CMDFullName
    $output = Get-ProcessTable | findstr $CMDName | findstr $cmd.Id
    EvalTest $MyInvocation.MyCommand.Name ($output)
    Stop-Process -Force -Id $cmd.Id
}

function Test-2DifferentProcessesRun {
    $cmd1 = Start-Proc $CMDFullName
    $cmd2 = Start-Proc $CMDFullName
    $outputCMD1 = Get-ProcessTable | findstr $CMDName | findstr $cmd1.Id
    $outputCMD2 = Get-ProcessTable | findstr $CMDName | findstr $cmd2.Id
    EvalTest $MyInvocation.MyCommand.Name ($outputCMD1 -and $outputCMD2)
    Stop-Process -Force -Id $cmd1.Id
    Stop-Process -Force -Id $cmd2.Id
}

function Test-RunProcessAndClose {
    $cmd = Start-Proc $CMDFullName
    $outputCMD1 = Get-ProcessTable | findstr $CMDName | findstr $cmd.Id
    Stop-Process -Force -Id $cmd.Id
    $outputCMD2 = Get-ProcessTable | findstr $CMDName | findstr $cmd.Id

    EvalTest $MyInvocation.MyCommand.Name ($outputCMD1 -and  !$outputCMD2)
}

function Test-MemUsage200MB {
    # Allocate 200 MB in new created powershell process.
    # Sleep 60 to prevent process exit after creating.
    $pwsh = Start-Process $PWSHFullName -ArgumentList "-Command", "[void]('x' * (200 * 1024 * 1024)); sleep 60" -WindowStyle Hidden -PassThru
    # Wait until all memory (200 MB) will be allocated.
    Start-Sleep 4
    $outputPWSH = Get-ProcessTable | findstr $PWSHName | findstr $pwsh.Id
    # Extract memory usage of the new created process
    $memUsage = ($outputPWSH -split '\s+')[2] -as [double]
    # Write-Output $outputPWSH
    Write-Output "mem: $memUsage"
    Write-Output $pwsh.Id

    EvalTest $MyInvocation.MyCommand.Name ($memUsage -ge 200)
    Stop-Process -Force -Id $pwsh.Id
}

# Run test cases
Test-MemUsage200MB
Test-NewProcessRun
Test-2DifferentProcessesRun
Test-RunProcessAndClose

exit $TestResult
