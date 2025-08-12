#!/bin/bash

find_and_replace() {
  echo "Search for:"
  read search_string

  if [ -z "$search_string" ]; then
    echo "Empty search string. Exiting."
    exit 1
  fi

  files=$(grep -r -l -F "$search_string" . 2>/dev/null)

  if [ -z "$files" ]; then
    echo "No matches found."
    exit 0
  fi

  echo "Found in:"
  echo "$files"
  echo

  echo "Replace with:"
  read replacement_string

  if [ -z "$replacement_string" ]; then
    echo "Cancelled."
    exit 0
  fi

  echo "Proceed? (y/N)"
  read confirm

  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Cancelled."
    exit 0
  fi

  count=0
  for file in $files; do
    if [ -f "$file" ]; then
      awk -v search="$search_string" -v replace="$replacement_string" '{
        gsub(search, replace)
        print
      }' "$file" > "$file.tmp" && mv "$file.tmp" "$file" && count=$((count + 1))
    fi
  done

  echo "Modified $count files."
}

find_and_replace
