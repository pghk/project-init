#!/bin/bash

# Memorable words array for folder naming
MEMORABLE_WORDS=(
    "alpha" "bravo" "charlie" "delta" "echo" "foxtrot" "golf" "hotel"
    "india" "juliet" "kilo" "lima" "mike" "november" "oscar" "papa"
    "quebec" "romeo" "sierra" "tango" "uniform" "victor" "whiskey" "x-ray" "yankee" "zulu"
)

# Function to get a random memorable word for folder naming
get_memorable_word() {
    local array_length=${#MEMORABLE_WORDS[@]}
    local random_index=$((RANDOM % array_length))
    echo "${MEMORABLE_WORDS[random_index]}"
}

# Function to generate a unique folder name with date and memorable word
generate_folder_name() {
    local memorable_word=$(get_memorable_word)
    local current_year=$(date +%Y)
    local brief_date="${current_year: -1}$(date +%m)"
    echo "${brief_date}-${memorable_word}"
}

# Function to create a project directory
create_project_directory() {
    local directory_name="$1"

    # If no directory name provided, generate one
    if [ -z "$directory_name" ]; then
        directory_name=$(generate_folder_name)
    fi

    # Check if directory already exists
    if [ -d "$directory_name" ]; then
        echo "Error: Directory '$directory_name' already exists" >&2
        return 1
    fi

    # Create the directory
    if mkdir "$directory_name" 2>/dev/null; then
        echo "$directory_name"
        return 0
    else
        echo "Error: Failed to create directory '$directory_name'" >&2
        return 1
    fi
}

# Function to generate boilerplate files in a directory
generate_boilerplate_files() {
    local target_directory="$1"

    # Check if directory exists
    if [ ! -d "$target_directory" ]; then
        echo "Error: Directory '$target_directory' does not exist" >&2
        return 1
    fi

    # Check if templates directory exists
    if [ ! -d "templates" ]; then
        echo "Error: Templates directory does not exist" >&2
        return 1
    fi

    # Copy template files to target directory
    local template_files=("README.md" "TODO.md" "MEMORY.md" "AGENT.md")

    for template_file in "${template_files[@]}"; do
        if [ -f "templates/$template_file" ]; then
            cp "templates/$template_file" "$target_directory/$template_file"
        else
            echo "Error: Template file 'templates/$template_file' does not exist" >&2
            return 1
        fi
    done

    return 0
}

# Function to create a project directory with boilerplate files
create_project_with_boilerplate() {
    local directory_name="$1"

    # Create the directory first
    local created_dir
    created_dir=$(create_project_directory "$directory_name")
    local create_exit_code=$?

    # If directory creation failed, return the error
    if [ $create_exit_code -ne 0 ]; then
        return $create_exit_code
    fi

    # Generate boilerplate files in the created directory
    if generate_boilerplate_files "$created_dir"; then
        echo "$created_dir"
        return 0
    else
        echo "Error: Failed to generate boilerplate files in '$created_dir'" >&2
        return 1
    fi
}

# Function to initialize a git repository in a directory with initial commit
initialize_git_repository() {
    local target_directory="$1"

    # Check if directory exists
    if [ ! -d "$target_directory" ]; then
        echo "Error: Directory '$target_directory' does not exist" >&2
        return 1
    fi

    # Initialize git repository and create initial commit
    if (cd "$target_directory" && {
        # Initialize git repository if not already initialized
        if [ ! -d ".git" ]; then
            git init --quiet 2>/dev/null || return 1
        fi

        # Configure git user if not already configured
        if [ -z "$(git config user.name 2>/dev/null)" ]; then
            git config user.name "Project Initializer" 2>/dev/null || return 1
        fi
        if [ -z "$(git config user.email 2>/dev/null)" ]; then
            git config user.email "init@example.com" 2>/dev/null || return 1
        fi

        # Add files and create initial commit if there are changes to commit
        git add . 2>/dev/null || return 1

        # Only commit if there are changes to commit
        if ! git diff --cached --quiet 2>/dev/null; then
            git commit --quiet -m "🎉 Initial commit with project boilerplate" 2>/dev/null || return 1
        fi

        return 0
    }); then
        return 0
    else
        echo "Error: Failed to initialize git repository with initial commit in '$target_directory'" >&2
        return 1
    fi
}

# Function to create a project directory with boilerplate files and git repository
create_project_with_git() {
    local directory_name="$1"

    # Create the directory and boilerplate files first
    local created_dir
    created_dir=$(create_project_with_boilerplate "$directory_name")
    local create_exit_code=$?

    # If project creation failed, return the error
    if [ $create_exit_code -ne 0 ]; then
        return $create_exit_code
    fi

    # Initialize git repository in the created directory
    if initialize_git_repository "$created_dir"; then
        echo "$created_dir"
        return 0
    else
        echo "Error: Failed to initialize git repository in '$created_dir'" >&2
        return 1
    fi
}

# Function to display help information
show_help() {
    cat << 'EOF'
Project Initializer - Create new development projects with boilerplate files

Usage: ./script.sh [directory_name]
       ./script.sh [--help|-h|help]

Arguments:
  directory_name    Optional name for the project directory
                   If not provided, a unique name will be generated
                   using format: YMM-memorableword (e.g., 506-lima)

Options:
  --help, -h, help  Show this help message

Examples:
  ./script.sh                    # Create project with generated name
  ./script.sh my-project         # Create project named "my-project"
  ./script.sh --help             # Show this help message

What this script creates:
  - Project directory with specified or generated name
  - README.md with project overview template
  - TODO.md for task tracking
  - MEMORY.md for project state tracking
  - AGENT.md with development guidelines
  - Git repository initialized and ready for commits

The generated directory name uses YMM format (last digit of year + month)
followed by a memorable word for chronological sorting and easy recall.
EOF
}

# Function to handle main script execution
main() {
    local directory_name=""

    # Parse command line arguments
    case "$#" in
        0)
            # No arguments - use generated name
            directory_name=""
            ;;
        1)
            case "$1" in
                --help|-h|help)
                    show_help
                    exit 0
                    ;;
                *)
                    # Single argument - use as directory name
                    directory_name="$1"
                    ;;
            esac
            ;;
        *)
            echo "Error: Too many arguments provided" >&2
            echo "" >&2
            show_help
            exit 1
            ;;
    esac

    # Demonstrate core functionality
    echo "Random memorable word: $(get_memorable_word)"
    echo "Generated folder name: $(generate_folder_name)"
    echo "Creating project directory with boilerplate and git..."

    # Create the project
    local created_dir
    created_dir=$(create_project_with_git "$directory_name")
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "Created project directory with boilerplate and git: $created_dir"
        echo "Files created:"
        ls -la "$created_dir"
        echo "Git repository initialized with initial commit"
        exit 0
    else
        echo "Failed to create project directory with boilerplate and git" >&2
        exit $exit_code
    fi
}

# If script is run directly (not sourced), execute main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
