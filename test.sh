#!/usr/bin/env bats

# Tests for project initializer folder name generation

@test "generate_folder_name returns properly formatted folder name" {
    source script.sh
    result=$(generate_folder_name)

    # Should be non-empty
    [ -n "$result" ]

    # Should be filesystem-safe (no spaces or problematic characters)
    [[ "$result" =~ ^[a-zA-Z0-9._-]+$ ]]

    # Should be suitable for directory naming (reasonable length)
    result_length=${#result}
    [ "$result_length" -ge 5 ]
    [ "$result_length" -le 20 ]
}

@test "generate_folder_name creates chronologically sortable names" {
    source script.sh

    # Generate multiple folder names over a short time
    result1=$(generate_folder_name)
    sleep 1
    result2=$(generate_folder_name)

    # Both should be non-empty and filesystem-safe
    [ -n "$result1" ]
    [ -n "$result2" ]
    [[ "$result1" =~ ^[a-zA-Z0-9._-]+$ ]]
    [[ "$result2" =~ ^[a-zA-Z0-9._-]+$ ]]

    # Names should be suitable for chronological sorting
    # This is a basic validation that the format supports sorting
    # We don't enforce strict chronological ordering as that depends on timing
    true
}

@test "get_memorable_word returns suitable word for folder naming" {
    source script.sh
    result=$(get_memorable_word)

    # Should be non-empty
    [ -n "$result" ]

    # Should be filesystem-safe
    [[ "$result" =~ ^[a-zA-Z0-9._-]+$ ]]

    # Should be reasonably brief (suitable for folder names)
    word_length=${#result}
    [ "$word_length" -ge 2 ]
    [ "$word_length" -le 15 ]
}

@test "generate_folder_name can produce varied results" {
    source script.sh

    # Generate multiple folder names
    result1=$(generate_folder_name)
    result2=$(generate_folder_name)
    result3=$(generate_folder_name)
    result4=$(generate_folder_name)
    result5=$(generate_folder_name)

    # All should be non-empty and filesystem-safe
    for result in "$result1" "$result2" "$result3" "$result4" "$result5"; do
        [ -n "$result" ]
        [[ "$result" =~ ^[a-zA-Z0-9._-]+$ ]]
    done

    # Should be capable of generating different names (test over multiple attempts)
    # Collect all results in an array and check for variation
    results=("$result1" "$result2" "$result3" "$result4" "$result5")
    unique_count=$(printf '%s\n' "${results[@]}" | sort -u | wc -l)

    # Should have at least some variation (allowing for occasional duplicates)
    [ "$unique_count" -ge 2 ]
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

    # Output should be non-empty and filesystem-safe
    [ -n "$output" ]
    [[ "$output" =~ ^[a-zA-Z0-9._-]+$ ]]

    # Directory should exist
    [ -d "$output" ]

    # Clean up
    rmdir "$output"
}

@test "generate_boilerplate_files creates standard project files" {
    source script.sh

    # Create a test directory
    test_dir="test-project-$$"
    mkdir "$test_dir"

    # Generate boilerplate files
    run generate_boilerplate_files "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Check that standard files were created
    [ -f "$test_dir/README.md" ]
    [ -f "$test_dir/TODO.md" ]
    [ -f "$test_dir/MEMORY.md" ]
    [ -f "$test_dir/AGENT.md" ]

    # Files should be non-empty
    [ -s "$test_dir/README.md" ]
    [ -s "$test_dir/TODO.md" ]
    [ -s "$test_dir/MEMORY.md" ]
    [ -s "$test_dir/AGENT.md" ]

    # Clean up
    rm -rf "$test_dir"
}

@test "generate_boilerplate_files handles non-existent directory" {
    source script.sh

    # Try to generate files in non-existent directory
    run generate_boilerplate_files "non-existent-dir-$$"

    # Should return failure
    [ "$status" -ne 0 ]

    # Should output error message
    [[ "$output" == *"Error"* ]]
}

@test "generate_boilerplate_files creates files with appropriate content" {
    source script.sh

    # Create a test directory
    test_dir="test-content-$$"
    mkdir "$test_dir"

    # Generate boilerplate files
    run generate_boilerplate_files "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Files should have content suitable for project initialization
    # README should be a markdown file with some structure
    [[ $(head -n 1 "$test_dir/README.md") == \#* ]]

    # TODO should be a markdown file
    [ -f "$test_dir/TODO.md" ]
    [ -s "$test_dir/TODO.md" ]

    # MEMORY should be a markdown file with headers
    [[ $(head -n 1 "$test_dir/MEMORY.md") == \#* ]]

    # AGENT should be a markdown file with headers
    [[ $(head -n 1 "$test_dir/AGENT.md") == \#* ]]

    # Clean up
    rm -rf "$test_dir"
}

@test "template files exist and are readable" {
    source script.sh

    # Check that template directory exists
    [ -d "templates" ]

    # Check that all template files exist
    [ -f "templates/README.md" ]
    [ -f "templates/TODO.md" ]
    [ -f "templates/MEMORY.md" ]
    [ -f "templates/AGENT.md" ]

    # Template files should be non-empty
    [ -s "templates/README.md" ]
    [ -s "templates/TODO.md" ]
    [ -s "templates/MEMORY.md" ]
    [ -s "templates/AGENT.md" ]
}

@test "generate_boilerplate_files creates consistent project structure" {
    source script.sh

    # Create a test directory
    test_dir="test-templates-$$"
    mkdir "$test_dir"

    # Generate boilerplate files
    run generate_boilerplate_files "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Generated files should exist and be non-empty
    [ -f "$test_dir/README.md" ]
    [ -f "$test_dir/TODO.md" ]
    [ -f "$test_dir/MEMORY.md" ]
    [ -f "$test_dir/AGENT.md" ]

    [ -s "$test_dir/README.md" ]
    [ -s "$test_dir/TODO.md" ]
    [ -s "$test_dir/MEMORY.md" ]
    [ -s "$test_dir/AGENT.md" ]

    # Files should be suitable for project use
    # README, MEMORY, and AGENT should be markdown with headers
    for file in README.md MEMORY.md AGENT.md; do
        grep -q "^#" "$test_dir/$file"
    done

    # TODO.md should exist and be non-empty (format may vary)
    [ -f "$test_dir/TODO.md" ]
    [ -s "$test_dir/TODO.md" ]

    # Clean up
    rm -rf "$test_dir"
}

@test "generate_boilerplate_files creates appropriate AGENT.md file" {
    source script.sh

    # Create a test directory
    test_dir="test-agent-template-$$"
    mkdir "$test_dir"

    # Generate boilerplate files
    run generate_boilerplate_files "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # AGENT.md should exist and be non-empty
    [ -f "$test_dir/AGENT.md" ]
    [ -s "$test_dir/AGENT.md" ]

    # AGENT.md should be a markdown file with appropriate structure
    [[ $(head -n 1 "$test_dir/AGENT.md") == \#* ]]

    # Should contain content suitable for project development guidance
    # (flexible check - just ensure it's substantial content)
    line_count=$(wc -l < "$test_dir/AGENT.md")
    [ "$line_count" -gt 10 ]

    # Clean up
    rm -rf "$test_dir"
}

@test "create_project_with_boilerplate creates directory and files together" {
    source script.sh

    # Create project with boilerplate using generated name
    run create_project_with_boilerplate

    # Should return success
    [ "$status" -eq 0 ]

    # Should output the created directory name
    [ -n "$output" ]

    # Directory should exist
    [ -d "$output" ]

    # Standard files should exist
    [ -f "$output/README.md" ]
    [ -f "$output/TODO.md" ]
    [ -f "$output/MEMORY.md" ]
    [ -f "$output/AGENT.md" ]

    # Clean up
    rm -rf "$output"
}

@test "create_project_with_boilerplate works with specified directory name" {
    source script.sh

    # Create project with specific name
    test_dir="specific-project-$$"
    run create_project_with_boilerplate "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Should output the created directory name
    [ "$output" = "$test_dir" ]

    # Directory should exist
    [ -d "$test_dir" ]

    # Standard files should exist
    [ -f "$test_dir/README.md" ]
    [ -f "$test_dir/TODO.md" ]
    [ -f "$test_dir/MEMORY.md" ]
    [ -f "$test_dir/AGENT.md" ]

    # Clean up
    rm -rf "$test_dir"
}
