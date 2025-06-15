# Project Memory

## Current State
This is a bash project initializer that creates new development projects with boilerplate files.

## Implemented Features
- `get_memorable_word()` function that returns a random memorable word for folder naming
- `generate_folder_name()` function that creates unique folder names with brief date (YMM) and memorable word
- `create_project_directory()` function that creates project directories with generated or specified names
- `generate_boilerplate_files()` function that creates standard project files in a directory
- `create_project_with_boilerplate()` function that creates directories and populates them with boilerplate files
- Memorable words array with 26 carefully selected words (alpha through zulu)
- Comprehensive test suite using bats framework with 13 behavioral test cases:
  - Validates properly formatted folder names (date-word with dash separator)
  - Tests chronologically sortable date format (YMM)
  - Validates memorable words (lowercase, filesystem-safe, appropriate length)
  - Tests folder name uniqueness and randomness over multiple calls
  - Tests successful directory creation with generated names
  - Tests graceful handling of existing directories
  - Tests directory creation with auto-generated names
  - Tests proper return values and output from directory creation
  - Tests boilerplate file generation in existing directories
  - Tests error handling for non-existent directories
  - Tests content validation of generated boilerplate files
  - Tests integrated project creation with boilerplate files
  - Tests project creation with specified directory names

## Project Structure
- `script.sh`: Main bash script with project initialization functionality
- `test.sh`: Bats test framework file with comprehensive tests
- `README.md`: Project description and overview
- `TODO.md`: Task tracking (boilerplate generation task completed)
- `AGENT.md`: Development rules and guidelines
- `MEMORY.md`: This file - project state tracking

## Technical Details
- Uses bash RANDOM variable for random index generation
- Script can be sourced for function access or run directly for demonstration
- All tests passing with bats framework (13 tests total)
- `get_memorable_word()` returns one of 26 carefully selected memorable words
- `generate_folder_name()` uses `date +%y%m` for brief date format with memorable word
- `create_project_directory()` creates directories and handles errors gracefully
- `generate_boilerplate_files()` creates README.md, TODO.md, MEMORY.md, and AGENT.md files
- `create_project_with_boilerplate()` combines directory creation with file generation
- Folder name format: YMM-memorableword (e.g., "2406-lima")
- Script is executable with proper shebang line
- Boilerplate files include appropriate content templates for new projects
- AGENT.md is copied from current project if available, otherwise uses fallback template
- Clean implementation focused on project initialization behavior
- Function names and comments focus on what they do, not how they do it
- Tests focus on behavioral requirements rather than implementation details
- Flexible design allows for future changes to word selection algorithm
- Directory creation includes error handling for existing directories
- Boilerplate generation includes error handling for non-existent directories
- Functions return created directory name on success, error messages on failure

## Next Steps
Core folder name generation, directory creation, and boilerplate file generation functionality is complete with brief YMM date format, behavioral function names and comprehensive tests. The project needs additional features to fulfill its goal as a project initializer:
- Git repository initialization functionality
- Main script logic to tie everything together
- Consider making the word selection algorithm configurable for different use cases
- Consider adding templates for different project types