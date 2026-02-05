#!/bin/bash
# MATLAB wrapper script

# Fix ~/.MathWorks permissions
mkdir -p "$HOME/.MathWorks"
chown "$USER":"$USER" "$HOME/.MathWorks"

# Disable GTK canberra module loading
export GTK_MODULES=""

# If there are arguments (file paths), open them at startup using -r
if [ $# -gt 0 ]; then
    files=""
    for f in "$@"; do
        # Escape single quotes and add to open command
        files="$files open('$f');"
    done
    LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/local/MATLAB/R2024a/bin/matlab -desktop -r "$files"
else
    LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/local/MATLAB/R2024a/bin/matlab -desktop
fi

