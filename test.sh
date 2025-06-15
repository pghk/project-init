#!/usr/bin/env bats

# Tests for project initializer folder name generation

@test "generate_folder_name returns properly formatted folder name" {
    source script.sh
    result=$(generate_folder_name)

    # Should be non-empty
    [ -n "$result" ]

    # Should contain a dash separator
    [[ "$result" == *"-"* ]]

    # Should have exactly one dash
    dash_count=$(echo "$result" | tr -cd '-' | wc -c)
    [ "$dash_count" -eq 1 ]

    # Extract the word part (after the dash)
    word_part=$(echo "$result" | cut -d'-' -f2)

    # Word part should be non-empty and lowercase
    [ -n "$word_part" ]
    lowercase_word=$(echo "$word_part" | tr '[:upper:]' '[:lower:]')
    [ "$word_part" = "$lowercase_word" ]

    # Word part should be filesystem-safe (no spaces or special chars except hyphens)
    [[ "$word_part" =~ ^[a-z0-9-]+$ ]]
}

@test "generate_folder_name returns chronologically sortable date" {
    source script.sh
    result=$(generate_folder_name)

    # Extract date part (before the dash)
    date_part=$(echo "$result" | cut -d'-' -f1)

    # Date part should be non-empty and numeric (YMM format)
    [ -n "$date_part" ]
    [[ "$date_part" =~ ^[0-9]{3}$ ]]

    # Should be current date (basic validation)
    current_date=$(date +%y%m)
    [ "$date_part" = "$current_date" ]
}

@test "get_memorable_word returns memorable word" {
    source script.sh
    result=$(get_memorable_word)

    # Should be non-empty
    [ -n "$result" ]

    # Should be lowercase
    lowercase_result=$(echo "$result" | tr '[:upper:]' '[:lower:]')
    [ "$result" = "$lowercase_result" ]

    # Should be filesystem-safe (letters, numbers, hyphens only)
    [[ "$result" =~ ^[a-z0-9-]+$ ]]

    # Should be reasonably brief (suitable for folder names)
    word_length=${#result}
    [ "$word_length" -ge 3 ]
    [ "$word_length" -le 10 ]
}

@test "generate_folder_name generates unique folder names" {
    source script.sh

    # Generate multiple folder names
    result1=$(generate_folder_name)
    result2=$(generate_folder_name)
    result3=$(generate_folder_name)

    # All should be non-empty
    [ -n "$result1" ]
    [ -n "$result2" ]
    [ -n "$result3" ]

    # Date parts should be identical (same day)
    date1=$(echo "$result1" | cut -d'-' -f1)
    date2=$(echo "$result2" | cut -d'-' -f1)
    date3=$(echo "$result3" | cut -d'-' -f1)
    [ "$date1" = "$date2" ]
    [ "$date2" = "$date3" ]

    # Should be able to generate different words (test randomness)
    # Note: This might occasionally fail due to randomness, but should usually pass
    word1=$(echo "$result1" | cut -d'-' -f2)
    word2=$(echo "$result2" | cut -d'-' -f2)
    word3=$(echo "$result3" | cut -d'-' -f2)

    # At least one should be different (very high probability)
    different_found=false
    if [[ "$word1" != "$word2" ]] || [[ "$word2" != "$word3" ]] || [[ "$word1" != "$word3" ]]; then
        different_found=true
    fi
    [ "$different_found" = true ]
}

@test "create_project_directory creates directory successfully" {
    source script.sh

    # Generate a test folder name
    test_folder=$(generate_folder_name)

    # Ensure directory doesn't exist initially
    [ ! -d "$test_folder" ]

    # Create the directory
    run create_project_directory "$test_folder"

    # Should return success (exit code 0)
    [ "$status" -eq 0 ]

    # Directory should now exist
    [ -d "$test_folder" ]

    # Clean up
    rmdir "$test_folder"
}

@test "create_project_directory handles existing directory gracefully" {
    source script.sh

    # Generate a test folder name
    test_folder=$(generate_folder_name)

    # Create directory manually first
    mkdir "$test_folder"

    # Try to create the same directory
    run create_project_directory "$test_folder"

    # Should return failure (non-zero exit code)
    [ "$status" -ne 0 ]

    # Directory should still exist
    [ -d "$test_folder" ]

    # Clean up
    rmdir "$test_folder"
}

@test "create_project_directory with generated name creates unique directory" {
    source script.sh

    # Create directory using generated name
    run create_project_directory

    # Should return success
    [ "$status" -eq 0 ]

    # Should output the created directory name
    [ -n "$output" ]

    # Directory should exist
    [ -d "$output" ]

    # Clean up
    rmdir "$output"
}

@test "create_project_directory returns created directory name" {
    source script.sh

    # Create directory using generated name
    run create_project_directory

    # Should return success
    [ "$status" -eq 0 ]

    # Output should be a valid folder name format
    [[ "$output" == *"-"* ]]

    # Should match expected pattern (YMM-word)
    [[ "$output" =~ ^[0-9]{3}-[a-z0-9-]+$ ]]

    # Directory should exist
    [ -d "$output" ]

    # Clean up
    rmdir "$output"
}
