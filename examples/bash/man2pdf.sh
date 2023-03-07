#!/bin/bash

CURDIR="$(dirname "$(realpath "$0")")"

cd "$CURDIR"

PATH=".:$PATH"

# create PDF
man2pdf "man" # creates man(1).pdf
man2pdf "man" "man.pdf" # creates man.pdf
man2pdf "man" "../out" # creates ../out/man(1).pdf

# clean up
rm -fv "man(1).pdf"
rm -fv "man.pdf"
rm -fv "../out/man(1).pdf"