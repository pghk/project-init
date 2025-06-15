#!/usr/bin/env bats

# Test for project initializer folder name generation

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

    # NATO part should be non-empty and lowercase
    [ -n "$nato_part" ]
    lowercase_nato=$(echo "$nato_part" | tr '[:upper:]' '[:lower:]')
    [ "$nato_part" = "$lowercase_nato" ]
}

@test "get_date_nato returns valid date format" {
    source script.sh
    result=$(get_date_nato)

    # Extract date part (before the dash)
    date_part=$(echo "$result" | cut -d'-' -f1)

    # Date part should be non-empty and numeric
    [ -n "$date_part" ]
    [[ "$date_part" =~ ^[0-9]+$ ]]
}

@test "get_lowercase_nato_word returns a valid lowercase NATO word" {
    source script.sh
    result=$(get_lowercase_nato_word)

    # Define valid lowercase NATO alphabet words
    lowercase_nato_words=(
        "alpha" "bravo" "charlie" "delta" "echo" "foxtrot" "golf" "hotel"
        "india" "juliet" "kilo" "lima" "mike" "november" "oscar" "papa"
        "quebec" "romeo" "sierra" "tango" "uniform" "victor" "whiskey" "x-ray" "yankee" "zulu"
    )

    # Check if the result is one of the valid lowercase NATO words
    found=false
    for word in "${lowercase_nato_words[@]}"; do
        if [[ "$result" == "$word" ]]; then
            found=true
            break
        fi
    done

    # Assert that we found a valid word
    [ "$found" = true ]
}

@test "get_lowercase_nato_word returns non-empty string" {
    source script.sh
    result=$(get_lowercase_nato_word)
    [ -n "$result" ]
}
