#!/bin/bash
set -e
# Check if all parameters are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <filename> <search_characters> <append_characters>"
    exit 1
fi

filename=$1
search_chars=$2
append_chars=$3

# Escape special characters in search_chars and append_chars
search_chars_escaped=$(sed 's/[][\/.^$*]/\\&/g' <<< "$search_chars")
append_chars_escaped=$(sed 's/[\/&]/\\&/g' <<< "$append_chars")

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File $filename not found."
    exit 1
fi

# Create a temporary file
temp_file=$(mktemp)

# Process the file line by line
while IFS= read -r line; do
    if [[ "$line" =~ $search_chars_escaped ]]; then
        line=$(sed "s/$search_chars_escaped/$search_chars_escaped$append_chars_escaped/g" <<< "$line")
    fi
    echo "$line" >> "$temp_file"
done < "$filename"

# Move the temporary file back to overwrite the original file
mv "$temp_file" "$filename"


