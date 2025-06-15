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

    # Generate a few names from current month
    name1=$(generate_folder_name)
    name2=$(generate_folder_name)
    name3=$(generate_folder_name)

    # Test 1: Verify date prefix format supports chronological sorting
    # Extract date prefix (should be YMM format - last digit of year + month)
    if [[ "$name1" =~ ^([0-9]{3})-.*$ ]]; then
        date_part="${BASH_REMATCH[1]}"

        # Should be current YMM (last digit of year + month)
        current_year=$(date +%Y)
        current_ymm="${current_year: -1}$(date +%m)"
        [ "$date_part" = "$current_ymm" ]

        # Verify format is chronologically sortable within same decade
        # YMM format sorts chronologically: 501 < 502 < 512 < 601
        [ ${#date_part} -eq 3 ]
        [[ "$date_part" =~ ^[0-9]{3}$ ]]
    else
        echo "Name doesn't match expected YMM-word format: $name1"
        return 1
    fi

    # Test 2: Demonstrate chronological sorting capability
    # Create test names representing different months within same decade
    test_names=(
        "501-alpha"   # January 2025
        "502-bravo"   # February 2025
        "512-charlie" # December 2025
        "601-delta"   # January 2026
    )

    # These should sort chronologically when sorted lexicographically
    IFS=$'\n' sorted_test_names=($(sort <<<"${test_names[*]}"))

    # Verify they sorted in chronological order
    expected=("501-alpha" "502-bravo" "512-charlie" "601-delta")
    for i in "${!expected[@]}"; do
        [ "${sorted_test_names[$i]}" = "${expected[$i]}" ]
    done

    # Test 3: Names from same month don't need to be chronologically ordered
    # (they have same date prefix, only word differs)
    # Just verify they all have the same date prefix
    current_year=$(date +%Y)
    current_month="${current_year: -1}$(date +%m)"
    for name in "$name1" "$name2" "$name3"; do
        [[ "$name" =~ ^${current_month}- ]]
    done
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
    # Files should be non-empty with appropriate content structure
    [ -s "$test_dir/README.md" ]
    [ -s "$test_dir/TODO.md" ]
    [ -s "$test_dir/MEMORY.md" ]
    [ -s "$test_dir/AGENT.md" ]

    # Files should contain text suitable for their purpose
    grep -q -i "project\|readme" "$test_dir/README.md"
    grep -q -i "todo\|task\|\[ \]\|\-" "$test_dir/TODO.md"
    grep -q -i "memory\|project\|state" "$test_dir/MEMORY.md"
    grep -q -i "agent\|development\|rules\|guidelines" "$test_dir/AGENT.md"

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

    # Files should be suitable for project use with appropriate content
    # Files should contain content relevant to their purpose
    grep -q -i "project\|readme" "$test_dir/README.md"
    grep -q -i "todo\|task\|\[ \]\|\-" "$test_dir/TODO.md"
    grep -q -i "memory\|project\|state" "$test_dir/MEMORY.md"
    grep -q -i "agent\|development\|rules\|guidelines" "$test_dir/AGENT.md"

    # All files should be substantial (not just placeholder text)
    for file in README.md TODO.md MEMORY.md AGENT.md; do
        [ -s "$test_dir/$file" ]
        line_count=$(wc -l < "$test_dir/$file")
        [ "$line_count" -gt 2 ]
    done

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

    # AGENT.md should contain appropriate development guidance content
    grep -q -i "development\|guidelines\|rules\|agent" "$test_dir/AGENT.md"

    # Should contain substantial content suitable for project guidance
    line_count=$(wc -l < "$test_dir/AGENT.md")
    [ "$line_count" -gt 10 ]

    # Should contain actionable guidance (look for common development terms)
    grep -q -i -E "(test|commit|task|step|process|workflow)" "$test_dir/AGENT.md"

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

@test "initialize_git_repository enables version control in project directory" {
    source script.sh

    # Create a test directory with some files to commit
    test_dir="test-git-$$"
    mkdir "$test_dir"
    echo "# Test Project" > "$test_dir/README.md"

    # Initialize git repository
    run initialize_git_repository "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Directory should be under version control with initial commit
    [ -d "$test_dir/.git" ]

    # Should have at least one commit
    cd "$test_dir"
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    [ "$commit_count" -gt 0 ]
    cd ..

    # Clean up
    rm -rf "$test_dir"
}

@test "initialize_git_repository handles non-existent directory" {
    source script.sh

    # Try to initialize git in non-existent directory
    run initialize_git_repository "non-existent-dir-$$"

    # Should return failure
    [ "$status" -ne 0 ]

    # Should output error message
    [[ "$output" == *"Error"* ]]
}

@test "initialize_git_repository handles existing version control gracefully" {
    source script.sh

    # Create a test directory with git repo and some content
    test_dir="test-existing-git-$$"
    mkdir "$test_dir"
    echo "# Test Project" > "$test_dir/README.md"
    cd "$test_dir"
    git init --quiet
    git config user.name "Test User"
    git config user.email "test@example.com"
    git add .
    git commit --quiet -m "Initial test commit"
    cd ..

    # Add new files to the directory (to test adding to existing repo)
    echo "# TODO" > "$test_dir/TODO.md"
    echo "# Memory" > "$test_dir/MEMORY.md"

    # Try to initialize git repository again (should handle gracefully and commit new files)
    run initialize_git_repository "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Directory should remain under version control
    [ -d "$test_dir/.git" ]

    # Should have multiple commits now (original + new files)
    cd "$test_dir"
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    [ "$commit_count" -gt 1 ]
    cd ..

    # Clean up
    rm -rf "$test_dir"
}

@test "create_project_with_git creates complete development-ready project" {
    source script.sh

    # Create project with git using generated name
    run create_project_with_git

    # Should return success
    [ "$status" -eq 0 ]

    # Should output the created directory name
    [ -n "$output" ]

    # Store directory name before it gets overwritten
    local created_dir="$output"

    # Directory should exist
    [ -d "$created_dir" ]

    # Standard project files should exist
    [ -f "$created_dir/README.md" ]
    [ -f "$created_dir/TODO.md" ]
    [ -f "$created_dir/MEMORY.md" ]
    [ -f "$created_dir/AGENT.md" ]

    # Project should be under version control
    [ -d "$created_dir/.git" ]

    # Clean up
    rm -rf "$created_dir"
}

@test "create_project_with_git supports custom project names" {
    source script.sh

    # Create project with git using specific name
    test_dir="specific-git-project-$$"
    run create_project_with_git "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Should output the created directory name
    [ "$output" = "$test_dir" ]

    # Directory should exist with specified name
    [ -d "$test_dir" ]

    # Standard project files should exist
    [ -f "$test_dir/README.md" ]
    [ -f "$test_dir/TODO.md" ]
    [ -f "$test_dir/MEMORY.md" ]
    [ -f "$test_dir/AGENT.md" ]

    # Project should be under version control
    [ -d "$test_dir/.git" ]

    # Clean up
    rm -rf "$test_dir"
}

# Tests for main script logic and command-line interface

@test "main script execution with no arguments creates project with generated name" {
    # Run script directly without arguments
    run ./script.sh

    # Should return success
    [ "$status" -eq 0 ]

    # Should output information about project creation
    [[ "$output" == *"Created project directory"* ]]

    # Should mention the created directory name
    [[ "$output" =~ Created\ project\ directory.*:\ ([a-zA-Z0-9._-]+) ]]
    created_dir="${BASH_REMATCH[1]}"

    # Directory should exist
    [ -d "$created_dir" ]

    # Should be a complete project with boilerplate and git
    [ -f "$created_dir/README.md" ]
    [ -f "$created_dir/TODO.md" ]
    [ -f "$created_dir/MEMORY.md" ]
    [ -f "$created_dir/AGENT.md" ]
    [ -d "$created_dir/.git" ]

    # Clean up
    rm -rf "$created_dir"
}

@test "main script execution with specified directory name creates named project" {
    test_dir="custom-main-test-$$"

    # Run script with custom directory name
    run ./script.sh "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Should output information about project creation with specified name
    [[ "$output" == *"Created project directory"* ]]
    [[ "$output" == *"$test_dir"* ]]

    # Directory should exist with specified name
    [ -d "$test_dir" ]

    # Should be a complete project with boilerplate and git
    [ -f "$test_dir/README.md" ]
    [ -f "$test_dir/TODO.md" ]
    [ -f "$test_dir/MEMORY.md" ]
    [ -f "$test_dir/AGENT.md" ]
    [ -d "$test_dir/.git" ]

    # Clean up
    rm -rf "$test_dir"
}

@test "main script shows help information when requested" {
    # Test various help flags
    run ./script.sh --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
    [[ "$output" == *"project initializer"* ]]

    run ./script.sh -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]

    run ./script.sh help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "main script handles invalid arguments gracefully" {
    # Test with multiple arguments (should only accept 0 or 1)
    run ./script.sh arg1 arg2 arg3

    # Should return failure
    [ "$status" -ne 0 ]

    # Should show error message and usage
    [[ "$output" == *"Error"* ]]
    [[ "$output" == *"Usage:"* ]]
}

@test "main script provides meaningful error messages for directory creation failures" {
    # Create a directory first to simulate existing directory error
    test_dir="existing-dir-$$"
    mkdir "$test_dir"

    # Try to create project with same name
    run ./script.sh "$test_dir"

    # Should return failure
    [ "$status" -ne 0 ]

    # Should show meaningful error message
    [[ "$output" == *"Error"* ]]
    [[ "$output" == *"already exists"* ]]

    # Clean up
    rmdir "$test_dir"
}

@test "main script provides informative success messages" {
    test_dir="success-message-test-$$"

    # Run script with custom directory name
    run ./script.sh "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Should provide informative output about what was created
    [[ "$output" == *"Created project directory"* ]]
    [[ "$output" == *"$test_dir"* ]]
    [[ "$output" == *"Files created"* ]]
    [[ "$output" == *"Git repository initialized"* ]]

    # Clean up
    rm -rf "$test_dir"
}

@test "main script demonstrates core functionality when run without arguments" {
    # Run script directly to test demonstration mode
    run ./script.sh

    # Should return success
    [ "$status" -eq 0 ]

    # Should show core functionality demonstrations
    [[ "$output" == *"Random memorable word:"* ]]
    [[ "$output" == *"Generated folder name:"* ]]
    [[ "$output" == *"Creating project directory"* ]]

    # Should create an actual project
    [[ "$output" =~ Created\ project\ directory.*:\ ([a-zA-Z0-9._-]+) ]]
    created_dir="${BASH_REMATCH[1]}"

    # Verify project was actually created
    [ -d "$created_dir" ]
    [ -f "$created_dir/README.md" ]
    [ -d "$created_dir/.git" ]

    # Clean up
    rm -rf "$created_dir"
}

@test "script has proper executable permissions" {
    # Check if script has execute permissions
    [ -x "./script.sh" ]
}

@test "script can be run without explicit bash invocation" {
    # Test that script can be executed directly without "bash script.sh"
    # This requires proper shebang line and executable permissions

    test_dir="exec-test-$$"

    # Run script directly (not via bash)
    run ./script.sh "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Should create project successfully
    [ -d "$test_dir" ]
    [ -f "$test_dir/README.md" ]
    [ -d "$test_dir/.git" ]

    # Clean up
    rm -rf "$test_dir"
}

@test "script has proper shebang for command-line tool execution" {
    # Verify the script has a proper shebang line for executable scripts
    first_line=$(head -n 1 script.sh)
    [[ "$first_line" =~ ^#!/.*/bash$ ]]
}

# Tests for initial git commit functionality

@test "git repository is initialized with initial commit" {
    source script.sh

    # Create a test directory and project
    test_dir="test-initial-commit-$$"
    run create_project_with_git "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Directory should exist with git repository
    [ -d "$test_dir" ]
    [ -d "$test_dir/.git" ]

    # Should have an initial commit
    cd "$test_dir"
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    [ "$commit_count" -gt 0 ]

    # Should have committed the boilerplate files
    git ls-files | grep -q "README.md"
    git ls-files | grep -q "TODO.md"
    git ls-files | grep -q "MEMORY.md"
    git ls-files | grep -q "AGENT.md"

    cd ..

    # Clean up
    rm -rf "$test_dir"
}

@test "initial commit has meaningful commit message" {
    source script.sh

    # Create a test directory and project
    test_dir="test-commit-message-$$"
    run create_project_with_git "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Check that commit message exists and is meaningful
    cd "$test_dir"
    commit_message=$(git log --oneline -1 --pretty=format:"%s" 2>/dev/null || echo "")
    [ -n "$commit_message" ]
    # Message should be substantial (not just whitespace or single character)
    [ ${#commit_message} -gt 5 ]

    cd ..

    # Clean up
    rm -rf "$test_dir"
}

@test "initial commit includes all boilerplate files" {
    source script.sh

    # Create a test directory and project
    test_dir="test-commit-files-$$"
    run create_project_with_git "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Check that all files are tracked in git
    cd "$test_dir"

    # All boilerplate files should be in the initial commit
    git show --name-only HEAD | grep -q "README.md"
    git show --name-only HEAD | grep -q "TODO.md"
    git show --name-only HEAD | grep -q "MEMORY.md"
    git show --name-only HEAD | grep -q "AGENT.md"

    cd ..

    # Clean up
    rm -rf "$test_dir"
}

@test "git commit functionality handles repository gracefully" {
    source script.sh

    # Create a test directory
    test_dir="test-git-graceful-$$"
    mkdir "$test_dir"

    # Create boilerplate files
    generate_boilerplate_files "$test_dir"

    # Initialize git repository manually (simulating existing repo)
    cd "$test_dir"
    git init --quiet
    cd ..

    # Function should handle existing repository gracefully
    run initialize_git_repository "$test_dir"
    [ "$status" -eq 0 ]

    # Clean up
    rm -rf "$test_dir"
}

@test "main script creates project with initial commit" {
    test_dir="main-commit-test-$$"

    # Run main script
    run ./script.sh "$test_dir"

    # Should return success
    [ "$status" -eq 0 ]

    # Directory should exist with git repository and initial commit
    [ -d "$test_dir" ]
    [ -d "$test_dir/.git" ]

    # Should have initial commit
    cd "$test_dir"
    commit_count=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    [ "$commit_count" -gt 0 ]

    # Initial commit should include boilerplate files
    git ls-files | grep -q "README.md"
    git ls-files | grep -q "TODO.md"
    git ls-files | grep -q "MEMORY.md"
    git ls-files | grep -q "AGENT.md"

    cd ..

    # Clean up
    rm -rf "$test_dir"
}
