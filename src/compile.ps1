$LIBS_DIR = "functionality"
$HEADER = "header.ps1"
$LIBS = @("process_lib.ps1")
$BASE_PROGRAM = "base.ps1"

$PROGRAM_NAME = "sys-info.ps1"

function PutContentIntoCompiled($filename) {
    Get-Content $LIBS_DIR\$filename >> $PROGRAM_NAME
}

# Remove previous compiled file
Remove-Item $PROGRAM_NAME

# Header must be first put into the output file
PutContentIntoCompiled $HEADER

ForEach($lib in $LIBS) {
    PutContentIntoCompiled $lib
}

PutContentIntoCompiled $BASE_PROGRAM