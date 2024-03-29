#!/bin/bash
set -e

echo Running versioner
# Read named command line arguments into an args variable
while getopts s:t: flag
do
    case "${flag}" in
        s) STRING_FILTER=${OPTARG};;
        t) TYPE=${OPTARG};;
    esac
done
# Check for existence of the input arguments
if [ -z "$TYPE" ]; then
    echo "Error: repo argument (-t) is required. Supports the values major, minor, build, none"
    exit 0
fi

# Gets all tags
# echo "*** Getting all tags"
# TAGS=$(git tag --sort=committerdate | grep $STRING_FILTER)
# echo "*** Tags Found $TAGS"

# Checks to see if a taxonomy value was given and filters the list
echo Getting Tags
if [ -n "$STRING_FILTER" ]; then
  echo Getting Tags on filter $STRING_FILTER
  TAGS=$(git tag --sort=committerdate | grep $STRING_FILTER) ||
  echo "Filtered Tag list on $STRING_FILTER - $TAGS"
else
  TAGS=$(git tag --sort=committerdate)
fi


if [ -z "$TAGS" ]; then
  VERSION="1.0.0"
  echo "No tag found based on filter version setting to $VERSION"
  echo "new version: $VERSION"
  echo "version=$(echo $VERSION)" >> $GITHUB_OUTPUT
  exit 0
else
  echo Found the Following Tags
  echo $TAGS
fi
echo extracting numbers from the tags
extracted_numbers=()
for string in $TAGS; do
  numbers=$(echo "$string" | grep -oE '[0-9]+(\.[0-9]+)*' | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+$') ||
  echo $numbers
  extracted_numbers+=("$numbers")
done

echo the following numbers have been extracted
echo ${extracted_numbers[*]}


# # Define a regular expression pattern for x.x.x format
# pattern="^[0-9]+\.[0-9]+\.[0-9]+$"
# for string in ${extracted_numbers[*]}; do
#   numbers=$(echo "$string" | grep -oE '[0-9]+(\.[0-9]+)*')
#   extracted_numbers+=("$numbers")
#   filter=$(echo "${numbers[@]}" | awk -v pattern="$pattern" '{ for(i=1; i<=NF; i++) if ($i ~ pattern) print $i }')
#   declare filter

# done
# declare -p filtered_list

# Define custom comparison function
version_compare() {
  local IFS=.
  local ver1=($1)
  local ver2=($2)
  local i

  # Iterate over version components
  for ((i=0; i<${#ver1[@]}; i++)); do
    if [[ -z ${ver2[i]} ]] || ((10#${ver1[i]} > 10#${ver2[i]})); then
      return 1
    elif ((10#${ver1[i]} < 10#${ver2[i]})); then
      return 2
    fi
  done

  if [[ ${#ver1[@]} -lt ${#ver2[@]} ]]; then
    return 2
  fi

  return 0
}

# Sort the array using custom comparison function
sorted_array=($(printf '%s\n' "${extracted_numbers[@]}" | sort -V))

for number in "${sorted_array[@]}"; do
  echo "$number"
done
# Print the last number in the array
last_index=$((${#sorted_array[@]} - 1))
last_number=${sorted_array[last_index]}
TAG=$last_number

if [ -z "$TAG" ]; then
  VERSION="1.0.0"
  echo "No tag found based on filter version setting to $VERSION"

else


major=0
minor=0
build=0

# break down the version number into it's components
OLD_VERSION=$(echo $TAG | sed 's/[[:alpha:]|(|[:space:]]//g' | sed 's/-//g')
echo $OLD_VERSION old ver
major=$(echo $OLD_VERSION | awk -F. '{print $1}')
minor=$(echo $OLD_VERSION | awk -F. '{print $2}')
build=$(echo $OLD_VERSION | awk -F. '{print $3}')


  # check paramater to see which number to increment
  if [ "$TYPE" = "build" ]; then
    build=$(echo $build + 1 | bc)
  elif [ "$TYPE" = "minor" ]; then
    minor=$(echo $minor + 1 | bc)
  elif [ "$TYPE" = "major" ]; then
    major=$(echo $major + 1 | bc)
  elif [ "$TYPE" = "none" ]; then
    major=$(echo $major + 0 | bc)
  else
    echo "usage: [major/minor/build]"
    exit -1
  fi


  VERSION=$(echo ${major}.${minor}.${build})
fi
# echo the new version number
echo "new version: $VERSION"
echo "version=$(echo $VERSION)" >> $GITHUB_OUTPUT
