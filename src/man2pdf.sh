#!/bin/bash

manpageName="$1"
outPath="$2"

# Check input arguments
if [ -z "$manpageName" ]
then
    echo "Usage: bash \"$0\" <man_page_name> [out_file.pdf]" >&2
    exit 1
fi

# Check ps2pdf
if ! which ps2pdf > /dev/null
then
    echo "[ERROR] ps2pdf not available. Please install GhostScript from https://www.ghostscript.com/." >&2
    exit 1
fi

# Handle convert
function HandleConvert {
    local manpageName="$1"
    local outPath="$2"

    # Ensure that the manpage actually exists
    if ! man -w "$manpageName" > /dev/null
    then
        # manpage file does not exist
        return 1
    fi

    # Set output file path
    local outFile="$outPath"
    # Case 1: If output path is not specified, then use manpage name as output filename.
    if [ -z "$outFile" ]
    then
        outFile="$manpageName.pdf"
    # Case 2: If output path is a directory, then use manpage name as output filename under output directory.
    elif [ -d "$outPath" ]
    then
        outFile="$outPath/$manpageName.pdf"
    # Case 3 (default): set output path as output file
    else
        :
    fi

    # Convert to PDF (will return non-zero if conversion fails)
    man -t "$manpageName" | ps2pdf - "$outFile"
}

HandleConvert "$manpageName" "$outPath"