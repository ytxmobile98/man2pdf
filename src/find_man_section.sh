#!/bin/bash

# Check arguments
if [ -n "$1" ] && [ -n "$2" ]
then
    manpage="$2($1)" # name(section), e.g. ls(1)
elif [ -n "$1" ]
then
    manpage="$1"
else
    echo "Usage: bash \"$0\" <manpage>" >&2
    echo "" >&2
    echo "<manpage> takes one of the following formats:" >&2
    echo "1. \`<section> <manpage_name>\`" >&2
    echo "2. \`<manpage_name>.<section>\`" >&2
    echo "3. \`<manpage_name>(<section>)\`" >&2
    echo "4. \`<manpage_name>\` (The section is resolved automatically)" >&2
    echo "" >&2
    echo "The output will have this format: \`<manpage_name>(<section>)\`" >&2

    exit 1
fi

function FindManpage {
    local manpage="$1"

    # Check if the manpage is valid
    if ! man -w "$manpage" > /dev/null
    then
        echo "[ERROR] Invalid manpage \"$manpage\"" >&2
        return 1
    fi

    # Convert to "name(section)" format
    local normalizedNameSection=""
    # Case 1: <manpage_name>.<section>
    # Notes:
    #   1. the . sign may be present in <manpage_name>
    #   2. paranetheses may not be present in the entire argument
    if [[ "$manpage" =~ ^([^()]+)\.([^.()]+)$ ]]
    then
        normalizedNameSection="${BASH_REMATCH[1]}(${BASH_REMATCH[2]})"
    # Case 2: <manpage_name>(<section>)
    # Notes:
    #   1. Parentheses may only be present around the <section> component, exactly once
    elif [[ "$manpage" =~ ^([^()]+)\(([^()]+)\)$ ]]
    then
        normalizedNameSection="${BASH_REMATCH[1]}(${BASH_REMATCH[2]})"
    fi

    if [ -n "$normalizedNameSection" ]
    then
        echo "$normalizedNameSection"
        return 0
    fi

    # Resolve manpage section if not given
    local firstMatchingManpage=$(man -f "$manpage" | head -n 1 | sed -E 's/^([^() \t\n\r\f\v]+)\s*\(([^()]+)\).*$/\1(\2)/g')
    if [ -n "$firstMatchingManpage" ]
    then
        normalizedNameSection="$firstMatchingManpage"
        echo "$normalizedNameSection"
        return 0
    fi

    echo "[ERROR] Unable to resolve manpage \"$manpage\"" >&2
    return 1
}

FindManpage "$manpage"