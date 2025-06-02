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

$NotepadFullName = "Notepad.exe"
$NotepadName = "Notepad"

$PWSHFullName = "powershell.exe"
$PWSHName = "powershell"

function Start-Proc($Proc) {
    $app = Start-Process $Proc -PassThru
    Write-Output "$Proc started with PID $app.Id"

    return $app
}

function Test-NewProcessRun {
    $appId = Start-Proc $CMDFullName
    $output = Get-ProcessTable | findstr $CMDName | findstr $appId.Id
    EvalTest $MyInvocation.MyCommand.Name ($output)
}

function Test-2DifferentProcessesRun {
    $cmd = Start-Proc $CMDFullName
    $notepad = Start-Proc $NotepadFullName
    $outputCMD = Get-ProcessTable | findstr $CMDName | findstr $cmd.Id
    $outputNotepad = Get-ProcessTable | findstr $NotepadName | findstr $notepad.Id
    EvalTest $MyInvocation.MyCommand.Name ($outputCMD -and $outputNotepad)
}

function Test-RunProcessAndClose {
    $cmd = Start-Proc $CMDFullName
    $outputCMD1 = Get-ProcessTable | findstr $CMDName | findstr $cmd.Id
    Stop-Process -Force -Id $cmd.Id
    $outputCMD2 = Get-ProcessTable | findstr $CMDName | findstr $cmd.Id

    EvalTest $MyInvocation.MyCommand.Name ($outputCMD1 -and  !$outputCMD2)
}

function Test-MemUsage400MB {
    $pwsh = Start-Process $PWSHFullName -ArgumentList '-NoExit', '-Command', "`$mem_alloc='a'*200MB" -PassThru
    # Wait until all memory (400 MB) will be allocated.
    # 400 = 2bytes per simbol * 200 symbols
    sleep 2
    $outputPWSH = Get-ProcessTable | findstr $PWSHName | findstr $pwsh.Id

    # Extract memory usage of the new created process
    $memUsage = Write-Output $outputPWSH | ForEach-Object {
        ($_ -split '\s+')[4] -as [double]
    }

    EvalTest $MyInvocation.MyCommand.Name ($memUsage -ge  400)
}

# Run test cases
Test-NewProcessRun
Test-2DifferentProcessesRun
Test-RunProcessAndClose
Test-MemUsage400MB

exit $TestResult