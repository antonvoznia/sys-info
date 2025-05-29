param (
    [Parameter(Mandatory = $false)]
    [switch]$Help,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile,

    [Parameter(Mandatory = $false)]
    [switch]$Json
)

# In script scope (outside param)
$knownParams = @('Help', 'Verbose', 'OutputFile', 'Json')
$passedParams = $PSCmdlet.MyInvocation.BoundParameters.Keys

foreach ($param in $passedParams) {
    if ($param -notin $knownParams) {
        Write-Output "Unknown parameter: -$param"
        exit 1
    }
}

