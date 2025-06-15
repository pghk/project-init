#!/bin/bash

# NATO alphabet words array
NATO_WORDS=(
    "Alpha" "Bravo" "Charlie" "Delta" "Echo" "Foxtrot" "Golf" "Hotel"
    "India" "Juliet" "Kilo" "Lima" "Mike" "November" "Oscar" "Papa"
    "Quebec" "Romeo" "Sierra" "Tango" "Uniform" "Victor" "Whiskey" "X-ray" "Yankee" "Zulu"
)

# Function to get a random NATO alphabet word
get_nato_word() {
    local array_length=${#NATO_WORDS[@]}
    local random_index=$((RANDOM % array_length))
    echo "${NATO_WORDS[random_index]}"
}

# If script is run directly (not sourced), demonstrate the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Random NATO alphabet word: $(get_nato_word)"
fi
