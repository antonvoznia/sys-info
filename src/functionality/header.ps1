param (
    [Parameter(Mandatory = $false)]
    [switch]$Help,

    [Parameter(Mandatory = $false)]
    [string]$OutputFile
)

# In script scope (outside param)
$knownParams = @('Help', 'Verbose', 'OutputFile')
$passedParams = $PSCmdlet.MyInvocation.BoundParameters.Keys

foreach ($param in $passedParams) {
    if ($param -notin $knownParams) {
        throw "Unknown parameter: -$param"
    }
}

