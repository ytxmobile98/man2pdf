#!/bin/bash

EXEC="$0"
CURDIR="$(dirname "$(realpath "$EXEC")")"

FIND_MAN_SECTION_EXEC="$CURDIR/find_man_section.sh"

function CheckHelpFlag {
    for arg in $@
    do
        if [ "$arg" = "-h" ] || [ "$arg" = "--help" ]
        then
            ShowHelpAndExit
            break
        fi
    done
}

function ShowHelpAndExit {
    local exitCode=$(expr "$1" \| 0)

    echo "Usage: bash \"$EXEC\" <manpage> [/path/to/out_file.pdf]" >&2
    echo "The <manpage> argument takes one of these forms:"
    echo "1. manpage name only: \`<manpage_name>\` (The section is resolved automatically)" >&2
    echo "2. section and manpage name: \`\"<section> <manpage_name>\"\`" >&2

    exit $exitCode
}

# Check input arguments
CheckHelpFlag $@
manpage="$1"
outPath="$2"
if [ -z "$manpage" ]
then
    ShowHelpAndExit 1
fi
# Note: The outPath is optional. If it is not given, it will be resolved automatically according to the manpage name.

# Check ps2pdf
if ! which ps2pdf > /dev/null
then
    echo "[ERROR] ps2pdf not available. Please install GhostScript from https://www.ghostscript.com/." >&2
    exit 1
fi

# Handle convert
function HandleConvert {
    local manpage="$1"
    local outPath="$2"

    # Find exact manpage with section number.
    # If failed, return 1.
    declare -a manpageWithSection
    manpageWithSection=($("$FIND_MAN_SECTION_EXEC" $manpage))
    if [ $? -ne 0 ]
    then
        return 1
    fi
    local section="${manpageWithSection[0]}"
    local manpageName="${manpageWithSection[1]}"
    echo "The manpage to process is: $manpageName($section)"

    # Set output file path
    local outFile="$manpageName($section).pdf"
    # Case 1: If output path is not specified, then use manpage name and section as output filename.
    if [ -z "$outPath" ]
    then
        :
    # Case 2: If output path is a directory, then use manpage name as output filename under output directory.
    elif [ -d "$outPath" ]
    then
        outFile="$outPath/$outFile"
    # Case 3 (default): set output path as output file
    else
        outFile="$outPath"
    fi

    # Convert to PDF (will return non-zero if conversion fails)
    man -t $manpage | ps2pdf - "$outFile" && echo "Saved output to \"$(realpath "$outFile")\"."
}

HandleConvert "$manpage" "$outPath"