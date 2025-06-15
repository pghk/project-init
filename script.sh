#!/bin/bash

# Lowercase NATO alphabet words array
LOWERCASE_NATO_WORDS=(
    "alpha" "bravo" "charlie" "delta" "echo" "foxtrot" "golf" "hotel"
    "india" "juliet" "kilo" "lima" "mike" "november" "oscar" "papa"
    "quebec" "romeo" "sierra" "tango" "uniform" "victor" "whiskey" "x-ray" "yankee" "zulu"
)

# Function to get a random lowercase NATO alphabet word
get_lowercase_nato_word() {
    local array_length=${#LOWERCASE_NATO_WORDS[@]}
    local random_index=$((RANDOM % array_length))
    echo "${LOWERCASE_NATO_WORDS[random_index]}"
}

# Function to get a brief date string concatenated with a lowercase NATO word
get_date_nato() {
    local lowercase_nato=$(get_lowercase_nato_word)
    local brief_date=$(date +%Y%m%d)
    echo "${brief_date}-${lowercase_nato}"
}

# If script is run directly (not sourced), demonstrate the functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Random lowercase NATO word: $(get_lowercase_nato_word)"
    echo "Date with NATO word: $(get_date_nato)"
fi
