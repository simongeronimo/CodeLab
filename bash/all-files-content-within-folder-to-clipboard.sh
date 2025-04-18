#!/bin/bash

(
  cd .
  for file in $(find . -type f); do
    echo "===== $file ====="
    cat "$file"
    echo
  done
) | xclip -selection clipboard

echo "All file contents where copied to the clipboard"
