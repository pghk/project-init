#!/bin/bash

# Memorable words array for folder naming
MEMORABLE_WORDS=(
    "alpha" "bravo" "charlie" "delta" "echo" "foxtrot" "golf" "hotel"
    "india" "juliet" "kilo" "lima" "mike" "november" "oscar" "papa"
    "quebec" "romeo" "sierra" "tango" "uniform" "victor" "whiskey" "x-ray" "yankee" "zulu"
)

# Function to get a random memorable word for folder naming
get_memorable_word() {
    local array_length=${#MEMORABLE_WORDS[@]}
    local random_index=$((RANDOM % array_length))
    echo "${MEMORABLE_WORDS[random_index]}"
}

# Function to generate a unique folder name with date and memorable word
generate_folder_name() {
    local memorable_word=$(get_memorable_word)
    local brief_date=$(date +%y%m)
    echo "${brief_date}-${memorable_word}"
}

# Function to create a project directory
create_project_directory() {
    local directory_name="$1"

    # If no directory name provided, generate one
    if [ -z "$directory_name" ]; then
        directory_name=$(generate_folder_name)
    fi

    # Check if directory already exists
    if [ -d "$directory_name" ]; then
        echo "Error: Directory '$directory_name' already exists" >&2
        return 1
    fi

    # Create the directory
    if mkdir "$directory_name" 2>/dev/null; then
        echo "$directory_name"
        return 0
    else
        echo "Error: Failed to create directory '$directory_name'" >&2
        return 1
    fi
}

# If script is run directly (not sourced), demonstrate the functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Random memorable word: $(get_memorable_word)"
    echo "Generated folder name: $(generate_folder_name)"
    echo "Creating project directory..."
    created_dir=$(create_project_directory)
    if [ $? -eq 0 ]; then
        echo "Created directory: $created_dir"
    else
        echo "Failed to create directory"
    fi
fi
