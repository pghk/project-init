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

    # README should contain project title
    grep -q "# Project" "$test_dir/README.md"

    # TODO should be a markdown file with proper structure
    grep -q "\[ \]" "$test_dir/TODO.md"

    # MEMORY should have proper section headers
    grep -q "# Project Memory" "$test_dir/MEMORY.md"
    grep -q "## Current State" "$test_dir/MEMORY.md"

    # AGENT should contain development rules
    grep -q "# Agent Task Checklist" "$test_dir/AGENT.md"

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

@test "generate_boilerplate_files uses template files" {
    source script.sh

    # Create a test directory
    test_dir="test-templates-$$"
    mkdir "$test_dir"

    # Generate boilerplate files
    run generate_boilerplate_files "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Generated files should match template content
    # We'll compare specific identifying content from templates

    # Check README template content is used
    if [ -f "templates/README.md" ]; then
        # First line should match between template and generated file
        template_first_line=$(head -n 1 "templates/README.md")
        generated_first_line=$(head -n 1 "$test_dir/README.md")
        [ "$template_first_line" = "$generated_first_line" ]
    fi

    # Check TODO template content is used
    if [ -f "templates/TODO.md" ]; then
        template_first_line=$(head -n 1 "templates/TODO.md")
        generated_first_line=$(head -n 1 "$test_dir/TODO.md")
        [ "$template_first_line" = "$generated_first_line" ]
    fi

    # Check MEMORY template content is used
    if [ -f "templates/MEMORY.md" ]; then
        template_first_line=$(head -n 1 "templates/MEMORY.md")
        generated_first_line=$(head -n 1 "$test_dir/MEMORY.md")
        [ "$template_first_line" = "$generated_first_line" ]
    fi

    # Clean up
    rm -rf "$test_dir"
}

@test "generate_boilerplate_files always uses AGENT.md template" {
    source script.sh

    # Create a test directory
    test_dir="test-agent-template-$$"
    mkdir "$test_dir"

    # Generate boilerplate files
    run generate_boilerplate_files "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # AGENT.md should exist
    [ -f "$test_dir/AGENT.md" ]

    # AGENT.md should match template content, not current project AGENT.md
    if [ -f "templates/AGENT.md" ]; then
        template_first_line=$(head -n 1 "templates/AGENT.md")
        generated_first_line=$(head -n 1 "$test_dir/AGENT.md")
        [ "$template_first_line" = "$generated_first_line" ]

        # Verify it's using the template by checking for generalized content
        # The template should not contain bash-specific content
        ! grep -q "bats framework" "$test_dir/AGENT.md"
        ! grep -q "source script.sh" "$test_dir/AGENT.md"
    fi

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
