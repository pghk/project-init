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
    local brief_date=$(date +%y%m)
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

    # Create README.md
    cat > "$target_directory/README.md" << 'EOF'
# Project

## Description
A new project created with the project initializer.

## Getting Started
Add your project setup instructions here.

## Usage
Add usage instructions here.

## Contributing
Add contribution guidelines here.
EOF

    # Create TODO.md
    cat > "$target_directory/TODO.md" << 'EOF'
- [ ] Set up project structure
- [ ] Add initial implementation
- [ ] Write tests
- [ ] Update documentation
EOF

    # Create MEMORY.md
    cat > "$target_directory/MEMORY.md" << 'EOF'
# Project Memory

## Current State
New project created with boilerplate files.

## Implemented Features
- Basic project structure
- Standard boilerplate files

## Project Structure
- `README.md`: Project overview and documentation
- `TODO.md`: Task tracking
- `MEMORY.md`: This file - project state tracking

## Technical Details
Add technical implementation details here as the project develops.

## Next Steps
- Define project requirements
- Implement core functionality
- Add comprehensive tests
- Update documentation
EOF

    # Create AGENT.md by copying from current project
    if [ -f "AGENT.md" ]; then
        cp "AGENT.md" "$target_directory/AGENT.md"
    else
        cat > "$target_directory/AGENT.md" << 'EOF'
# General Development Rules

You should do task-based development. For every task, you should write the tests, implement the code, and run the tests to make sure everything works.

When the tests pass:
* Update the todo list to reflect the task being completed
* Update the memory file to reflect the current state of the project
* Fix any warnings or errors in the code
* Commit the changes to the repository with a descriptive commit message
* Update the development guidelines to reflect anything that you've learned while working on the project
* Stop and we will open a new chat for the next task

## Retain Memory

There will be a memory file for every project.

The memory file will contain the state of the project, and any notes or relevant details you'd need to remember between chats.

Keep it up to date based on the project's current state.

Do not annotate task completion in the memory file. It will be tracked in the to-do list.

## Update development guidelines

If necessary, update the development guidelines to reflect anything you've learned while working on the project.
EOF
    fi

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

# If script is run directly (not sourced), demonstrate the functions
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Random memorable word: $(get_memorable_word)"
    echo "Generated folder name: $(generate_folder_name)"
    echo "Creating project directory with boilerplate..."
    created_dir=$(create_project_with_boilerplate)
    if [ $? -eq 0 ]; then
        echo "Created project directory with boilerplate: $created_dir"
        echo "Files created:"
        ls -la "$created_dir"
    else
        echo "Failed to create project directory with boilerplate"
    fi
fi
