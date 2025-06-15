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

# Function to get a brief date string concatenated with a lowercase NATO word
get_date_nato() {
    local nato_word=$(get_nato_word)
    local lowercase_nato=$(echo "$nato_word" | tr '[:upper:]' '[:lower:]')
    local brief_date=$(date +%Y%m%d)
    echo "${brief_date}-${lowercase_nato}"
}

# If script is run directly (not sourced), demonstrate the functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Random NATO alphabet word: $(get_nato_word)"
    echo "Date with NATO word: $(get_date_nato)"
fi
