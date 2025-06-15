#!/usr/bin/env bats

# Test for NATO alphabet random word function

@test "get_nato_word returns a valid NATO alphabet word" {
    # Source the script to get access to the function
    source script.sh

    # Get a random NATO word
    result=$(get_nato_word)

    # Define valid NATO alphabet words
    nato_words=(
        "Alpha" "Bravo" "Charlie" "Delta" "Echo" "Foxtrot" "Golf" "Hotel"
        "India" "Juliet" "Kilo" "Lima" "Mike" "November" "Oscar" "Papa"
        "Quebec" "Romeo" "Sierra" "Tango" "Uniform" "Victor" "Whiskey" "X-ray" "Yankee" "Zulu"
    )

    # Check if the result is one of the valid NATO words
    found=false
    for word in "${nato_words[@]}"; do
        if [[ "$result" == "$word" ]]; then
            found=true
            break
        fi
    done

    # Assert that we found a valid word
    [ "$found" = true ]
}

@test "get_nato_word returns non-empty string" {
    source script.sh
    result=$(get_nato_word)
    [ -n "$result" ]
}

@test "get_nato_word can be called multiple times" {
    source script.sh
    result1=$(get_nato_word)
    result2=$(get_nato_word)
    result3=$(get_nato_word)

    # All should be non-empty
    [ -n "$result1" ]
    [ -n "$result2" ]
    [ -n "$result3" ]
}
