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

$CMDFullName = "cmd.exe"
$CMDName = "cmd"
function Start-CMDProcess {
    $app = Start-Process $CMDFullName -PassThru
    Write-Output "$processName started with PID $app.Id"

    return $app
}

function Test-NewProcessRun {
    $appId = Start-CMDProcess
    $output = Get-ProcessTable | findstr $CMDName | findstr $appId.Id
    EvalTest $MyInvocation.MyCommand.Name ($output)
}

Test-NewProcessRun

exit $TestResult