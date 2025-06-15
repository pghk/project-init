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
    local brief_date=$(date +%Y%m%d)
    echo "${brief_date}-${memorable_word}"
}

# If script is run directly (not sourced), demonstrate the functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Random memorable word: $(get_memorable_word)"
    echo "Generated folder name: $(generate_folder_name)"
fi
