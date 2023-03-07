#!/bin/bash

EXEC="$0"

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

    echo "Usage: bash \"$EXEC\" <manpage>" >&2
    echo "" >&2
    echo "<manpage> takes one of the following formats:" >&2
    echo "1. \`<section> <manpage_name>\`" >&2
    echo "2. \`<manpage_name>.<section>\`" >&2
    echo "3. \`<manpage_name>(<section>)\`" >&2
    echo "4. \`<manpage_name>\` (The section is resolved automatically)" >&2
    echo "" >&2
    echo "The output will have this format: \`<manpage_name>(<section>)\`" >&2

    exit $exitCode
}

# Check arguments
CheckHelpFlag $@
if [ -n "$1" ] && [ -n "$2" ]
then
    manpage="$2($1)" # name(section), e.g. ls(1)
elif [ -n "$1" ]
then
    manpage="$1"
else
    ShowHelpAndExit 1
fi

function FindManpage {
    local manpage="$1"

    # Check if the manpage is valid
    # and if valid, get the filename
    local manpageFile=""
    manpageFile="$(man -w "$manpage")"
    if [ $? -ne 0 ]
    then
        echo "[ERROR] Invalid manpage \"$manpage\"" >&2
        return 1
    fi

    # Convert to manpage_name(section) format
    manpageFile="$(basename "$manpageFile" .gz)"
    local manpageName="${manpageFile%.*}"
    local section="${manpageFile##*.}"

    echo "$manpageName($section)"
}

FindManpage "$manpage"