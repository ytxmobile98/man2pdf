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

    echo "Usage: bash \"$EXEC\" [section] <manpage_name>" >&2
    echo "The output will have this format: \`<section> <manpage_name>\`" >&2

    exit $exitCode
}

# Usage: FindManPage [section] <manpage_name>
function FindManpage {
    local manpage=""

    local section=""
    local manpageName=""

    if [ -n "$1" ] && [ -n "$2" ]
    then
        section="$1"
        manpageName="$2"

        manpage="$section $manpageName"
    elif [ -n "$1" ]
    then
        section=""
        manpageName="$1"

        manpage="$manpageName"
    else
        echo "Usage: $0 [section] <manpage_name>" >&2
        return 1
    fi

    # Check if the manpage is valid
    # and if valid, get the filename
    local manpageFile=""
    manpageFile="$(man -w $manpage)"
    if [ $? -ne 0 ]
    then
        echo "[ERROR] Invalid manpage \"$manpage\"" >&2
        return 1
    fi

    # Convert to manpage_name(section) format
    local manpageFileBasename="$(basename "$manpageFile" .gz)" # may be gzipped
    if ! [[ "$manpageFileBasename" =~ ^(.+)\.(.+)$ ]]
    then
        echo "[ERROR] Invalid manpage file \"$manpageFile\"." >&2
        echo "The name should have the <manpage_name>.<section>[.gz] format, with an optional .gz suffix (for compressed manpages)." >&2
        return 1
    fi
    manpageName="${BASH_REMATCH[1]}"
    section="${BASH_REMATCH[2]}"
    echo "$section $manpageName"
}

# Check arguments
CheckHelpFlag $@
if [ -n "$1" ] && [ -n "$2" ]
then
    section="$1"
    manpageName="$2"

    FindManpage "$section" "$manpageName"
elif [ -n "$1" ]
then
    manpageName="$1"

    FindManpage "$manpageName"
else
    ShowHelpAndExit 1
fi