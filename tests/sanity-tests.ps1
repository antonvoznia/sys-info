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
function GetHelp {
    return & "$ScriptPath" -Help
}

function GetProcessTable {
    return & "$ScriptPath"
}

function GetProcessJson {
    return & "$ScriptPath" -Json
}

function Test-JsonCompat {
    param ([string]$Json)
    try {
        $null = $Json | ConvertFrom-Json
        return $true
    } catch {
        return $false
    }
}

# Sanity test functions
function CompareHelpTest {
    $OriginalHelp = @"
sys-info.ps1 [-Help] [-Verbose] [-Json] [-OutputFile <path>]

Options:
  -Help         Show this help message
  -OutputFile   Write results to the given file
  -Json         Output in JSON format
"@

    $Output = GetHelp
    EvalTest $MyInvocation.MyCommand.Name ($Output -eq $OriginalHelp)
}

function CheckDefaultOutputTest {
    $Output = GetProcessTable

    EvalTest $MyInvocation.MyCommand.Name ($Output)
}

function CheckColumnsTest {
    $Output = GetProcessTable | Out-String
    $Result = $Output.Contains("Id") -and $Output.Contains("Name") `
    -and $Output.Contains("CPU") -and $Output.Contains("User") `
    -and $Output.Contains("Mem")

    EvalTest $MyInvocation.MyCommand.Name ($Result)
}

function CheckValidityOfJsonTest {
    $Output = GetProcessJson
    $Result = Test-JsonCompat $Output

    EvalTest $MyInvocation.MyCommand.Name ($Result)
}



# Execute Sanity tests
CompareHelpTest
CheckDefaultOutputTest
CheckColumnsTest
CheckValidityOfJsonTest

exit $TestResult