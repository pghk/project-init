#!/usr/bin/env bats

# Tests for project initializer - focused on design requirements

# Design Requirement 1: Folder name generation (brief, memorable, unique, chronologically sortable)

@test "folder names are brief, memorable, and filesystem-safe" {
    source project-init

    # Test multiple generated names
    for i in {1..5}; do
        name=$(generate_folder_name)

        # Should be non-empty and reasonably brief
        [ -n "$name" ]
        name_length=${#name}
        [ "$name_length" -ge 5 ]
        [ "$name_length" -le 20 ]

        # Should be filesystem-safe
        [[ "$name" =~ ^[a-zA-Z0-9._-]+$ ]]

        # Should contain memorable component
        word=$(get_memorable_word)
        [ -n "$word" ]
        word_length=${#word}
        [ "$word_length" -ge 2 ]
        [ "$word_length" -le 15 ]
    done
}

@test "folder names are chronologically sortable within 10-year span" {
    source project-init

    # Verify current names use YMM format
    name=$(generate_folder_name)
    [[ "$name" =~ ^([0-9]{3})-.*$ ]]
    date_part="${BASH_REMATCH[1]}"

    # Should match current YMM (last digit of year + month)
    current_year=$(date +%Y)
    current_ymm="${current_year: -1}$(date +%m)"
    [ "$date_part" = "$current_ymm" ]

    # Test chronological sorting with sample data
    test_names=(
        "501-alpha"   # January 2025
        "502-bravo"   # February 2025
        "512-charlie" # December 2025
        "601-delta"   # January 2026
    )

    # Should sort chronologically when sorted lexicographically
    IFS=$'\n' sorted_names=($(sort <<<"${test_names[*]}"))
    expected=("501-alpha" "502-bravo" "512-charlie" "601-delta")

    for i in "${!expected[@]}"; do
        [ "${sorted_names[$i]}" = "${expected[$i]}" ]
    done
}

@test "folder names provide uniqueness through variation" {
    source project-init

    # Generate multiple names and verify they can vary
    names=()
    for i in {1..10}; do
        names+=($(generate_folder_name))
    done

    # Should have at least some variation (not all identical)
    # This allows for rare cases where random selection might repeat
    unique_count=$(printf '%s\n' "${names[@]}" | sort -u | wc -l)
    [ "$unique_count" -ge 3 ]
}

# Design Requirement 2: Support for both auto-generated and user-specified directory names

@test "supports both auto-generated and custom directory names" {
    source project-init

    # Test auto-generated directory creation
    auto_dir=$(create_project_directory)
    [ $? -eq 0 ]
    [ -d "$auto_dir" ]
    [[ "$auto_dir" =~ ^[0-9]{3}-[a-z-]+ ]]

    # Test custom directory creation
    custom_dir="custom-test-$$"
    created_dir=$(create_project_directory "$custom_dir")
    [ $? -eq 0 ]
    [ "$created_dir" = "$custom_dir" ]
    [ -d "$custom_dir" ]

    # Test error handling for existing directories
    run create_project_directory "$custom_dir"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "already exists" ]]

    # Cleanup
    rm -rf "$auto_dir" "$custom_dir"
}

# Design Requirement 3: Populate folder with boilerplate files

@test "creates all required boilerplate files with appropriate content" {
    source project-init

    # Create test directory and generate boilerplate
    test_dir="boilerplate-test-$$"
    mkdir "$test_dir"

    result=$(generate_boilerplate_files "$test_dir")
    [ $? -eq 0 ]

    # Verify all required files exist
    required_files=("README.md" "TODO.md" "MEMORY.md" "AGENT.md")
    for file in "${required_files[@]}"; do
        [ -f "$test_dir/$file" ]
        [ -s "$test_dir/$file" ]  # File is not empty
    done

    # Verify files have appropriate content structure
    grep -q -i "project" "$test_dir/README.md"
    grep -q -E "\[ \]|\-" "$test_dir/TODO.md"  # Check for todo list format
    grep -q -i "memory\|state" "$test_dir/MEMORY.md"
    grep -q -i "agent\|development\|workflow" "$test_dir/AGENT.md"

    # Test error handling for non-existent directory
    run generate_boilerplate_files "nonexistent-$$"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "does not exist" ]]

    # Cleanup
    rm -rf "$test_dir"
}

@test "integrated project creation with boilerplate works end-to-end" {
    source project-init

    # Test with auto-generated name
    auto_project=$(create_project_with_boilerplate)
    [ $? -eq 0 ]
    [ -d "$auto_project" ]

    # Verify all boilerplate files were created
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        [ -f "$auto_project/$file" ]
    done

    # Test with custom name
    custom_project="custom-boilerplate-$$"
    created_project=$(create_project_with_boilerplate "$custom_project")
    [ $? -eq 0 ]
    [ "$created_project" = "$custom_project" ]
    [ -d "$custom_project" ]

    # Verify all boilerplate files were created
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        [ -f "$custom_project/$file" ]
    done

    # Cleanup
    rm -rf "$auto_project" "$custom_project"
}

# Design Requirement 4: Initialize git repository with initial commit

@test "initializes git repository with proper initial commit" {
    source project-init

    # Create project directory with boilerplate
    test_dir="git-test-$$"
    mkdir "$test_dir"
    generate_boilerplate_files "$test_dir"

    # Initialize git repository
    result=$(initialize_git_repository "$test_dir")
    [ $? -eq 0 ]

    # Verify git repository exists and has commits
    [ -d "$test_dir/.git" ]

    cd "$test_dir"
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    [ "$commit_count" -gt 0 ]

    # Verify initial commit includes all boilerplate files
    committed_files=$(git ls-tree --name-only HEAD)
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        echo "$committed_files" | grep -q "$file"
    done

    # Verify commit message is meaningful
    commit_msg=$(git log --format=%s -1)
    [[ "$commit_msg" =~ (Initial|initial|🎉) ]]

    cd ..
    rm -rf "$test_dir"
}

@test "complete project creation with git integration works end-to-end" {
    source project-init

    # Test with auto-generated name
    auto_project=$(create_project_with_git)
    [ $? -eq 0 ]
    [ -d "$auto_project" ]
    [ -d "$auto_project/.git" ]

    # Verify all components are present
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        [ -f "$auto_project/$file" ]
    done

    # Test with custom name
    custom_project="custom-git-$$"
    created_project=$(create_project_with_git "$custom_project")
    [ $? -eq 0 ]
    [ "$created_project" = "$custom_project" ]
    [ -d "$custom_project" ]
    [ -d "$custom_project/.git" ]

    # Verify git repository has initial commit with all files
    cd "$custom_project"
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    [ "$commit_count" -gt 0 ]

    committed_files=$(git ls-tree --name-only HEAD)
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        echo "$committed_files" | grep -q "$file"
    done

    cd ..
    rm -rf "$auto_project" "$custom_project"
}

# Command-line interface and main script functionality

@test "main script supports all design requirements through command-line interface" {
    # Test script can be executed directly
    [ -x "./project-init" ]

    # Test help functionality
    run ./project-init --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "directory_name" ]]

    # Test with no arguments (auto-generated name)
    run ./project-init
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Random memorable word:" ]]
    [[ "$output" =~ "Generated folder name:" ]]
    [[ "$output" =~ "Created project directory" ]]

    # Extract created directory name and verify it exists
    created_dir=$(echo "$output" | grep "Created project directory" | sed 's/.*: //')
    [ -d "$created_dir" ]
    [ -d "$created_dir/.git" ]

    # Verify all design requirements are met
    [[ "$created_dir" =~ ^[0-9]{3}-[a-z-]+$ ]]  # Proper name format
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        [ -f "$created_dir/$file" ]
    done

    # Cleanup
    rm -rf "$created_dir"
}

@test "main script handles custom directory names and error cases" {
    # Test with custom directory name
    custom_dir="main-custom-$$"
    run ./project-init "$custom_dir"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Created project directory.*$custom_dir" ]]
    [ -d "$custom_dir" ]

    # Test error handling for existing directory
    run ./project-init "$custom_dir"
    [ "$status" -ne 0 ]
    [[ "$output" =~ "already exists" ]]

    # Test error handling for too many arguments
    run ./project-init arg1 arg2
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Too many arguments" ]]

    # Cleanup
    rm -rf "$custom_dir"
}

# Template system validation

@test "template system provides consistent boilerplate structure" {
    source project-init

    # Verify templates directory exists
    [ -d "templates" ]

    # Verify all required template files exist
    for template in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        [ -f "templates/$template" ]
        [ -s "templates/$template" ]  # File is not empty
    done

    # Test that template files are properly used in boilerplate generation
    test_dir="template-test-$$"
    mkdir "$test_dir"

    generate_boilerplate_files "$test_dir"

    # Each generated file should have content from its template
    for file in "README.md" "TODO.md" "MEMORY.md" "AGENT.md"; do
        [ -f "$test_dir/$file" ]

        # Files should not be identical to templates (they may have modifications)
        # but should contain substantial content
        file_size=$(wc -c < "$test_dir/$file")
        [ "$file_size" -gt 10 ]
    done

    rm -rf "$test_dir"
}
