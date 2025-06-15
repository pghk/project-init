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

@test "get_date_nato returns date with lowercase NATO word" {
    source script.sh
    result=$(get_date_nato)

    # Should be non-empty
    [ -n "$result" ]

    # Should contain a dash separator
    [[ "$result" == *"-"* ]]

    # Should have exactly one dash
    dash_count=$(echo "$result" | tr -cd '-' | wc -c)
    [ "$dash_count" -eq 1 ]

    # Extract the NATO word part (after the dash)
    nato_part=$(echo "$result" | cut -d'-' -f2)

    # NATO part should be non-empty
    [ -n "$nato_part" ]

    # NATO part should be lowercase
    lowercase_nato=$(echo "$nato_part" | tr '[:upper:]' '[:lower:]')
    [ "$nato_part" = "$lowercase_nato" ]

    # NATO part should be a valid NATO word (when converted to proper case)
    proper_case_nato=$(echo "$nato_part" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    nato_words=(
        "Alpha" "Bravo" "Charlie" "Delta" "Echo" "Foxtrot" "Golf" "Hotel"
        "India" "Juliet" "Kilo" "Lima" "Mike" "November" "Oscar" "Papa"
        "Quebec" "Romeo" "Sierra" "Tango" "Uniform" "Victor" "Whiskey" "X-ray" "Yankee" "Zulu"
    )

    found=false
    for word in "${nato_words[@]}"; do
        if [[ "$proper_case_nato" == "$word" ]]; then
            found=true
            break
        fi
    done
    [ "$found" = true ]
}

@test "get_date_nato returns consistent date format" {
    source script.sh
    result=$(get_date_nato)

    # Extract date part (before the dash)
    date_part=$(echo "$result" | cut -d'-' -f1)

    # Date part should be non-empty
    [ -n "$date_part" ]

    # Date part should be numeric (brief date format)
    [[ "$date_part" =~ ^[0-9]+$ ]]
}

@test "get_date_nato can be called multiple times" {
    source script.sh
    result1=$(get_date_nato)
    result2=$(get_date_nato)
    result3=$(get_date_nato)

    # All should be non-empty
    [ -n "$result1" ]
    [ -n "$result2" ]
    [ -n "$result3" ]

    # All should have the same date part (since called in quick succession)
    date1=$(echo "$result1" | cut -d'-' -f1)
    date2=$(echo "$result2" | cut -d'-' -f1)
    date3=$(echo "$result3" | cut -d'-' -f1)

    [ "$date1" = "$date2" ]
    [ "$date2" = "$date3" ]
}
