#!/bin/bash

# Check input arguments
manpage="$1"
outPath="$2"
if [ -z "$manpage" ]
then
    echo "Usage: bash \"$0\" <man_page_name> [out_file.pdf]" >&2
    exit 1
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

    # Ensure that the manpage actually exists
    if ! man -w "$manpage" > /dev/null
    then
        # manpage file does not exist
        return 1
    fi

    # Set output file path
    local outFile="$outPath"
    # Case 1: If output path is not specified, then use manpage name as output filename.
    if [ -z "$outFile" ]
    then
        outFile="$manpage.pdf"
    # Case 2: If output path is a directory, then use manpage name as output filename under output directory.
    elif [ -d "$outPath" ]
    then
        outFile="$outPath/$manpage.pdf"
    # Case 3 (default): set output path as output file
    else
        :
    fi

    # Convert to PDF (will return non-zero if conversion fails)
    man -t "$manpage" | ps2pdf - "$outFile" && echo "Saved output to \"$(realpath "$outFile")\"."
}

HandleConvert "$manpage" "$outPath"