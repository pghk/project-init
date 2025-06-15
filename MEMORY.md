# Project Memory

## Current State
This is a bash project initializer that creates new development projects with boilerplate files.

## Implemented Features
- `get_memorable_word()` function that returns a random memorable word for folder naming
- `generate_folder_name()` function that creates unique folder names with brief date (YMM) and memorable word
- `create_project_directory()` function that creates project directories with generated or specified names
- `generate_boilerplate_files()` function that creates standard project files from templates in a directory (always uses template for AGENT.md)
- `create_project_with_boilerplate()` function that creates directories and populates them with boilerplate files
- Memorable words array with 26 carefully selected words (alpha through zulu)
- Comprehensive test suite using bats framework with 16 flexible test cases:
  - Validates filesystem-safe folder names suitable for directory creation
  - Tests chronologically sortable name generation capability
  - Validates memorable words suitable for folder naming
  - Tests folder name variation capability over multiple calls
  - Tests successful directory creation with generated names
  - Tests graceful handling of existing directories
  - Tests directory creation with auto-generated names
  - Tests proper return values and output from directory creation
  - Tests boilerplate file generation in existing directories
  - Tests error handling for non-existent directories
  - Tests content validation of generated boilerplate files
  - Tests template file availability and readability
  - Tests consistent project structure creation
  - Tests appropriate AGENT.md file generation
  - Tests integrated project creation with boilerplate files
  - Tests project creation with specified directory names

## Project Structure
- `script.sh`: Main bash script with project initialization functionality
- `test.sh`: Bats test framework file with comprehensive tests
- `templates/`: Directory containing boilerplate file templates
  - `templates/README.md`: Project README template
  - `templates/TODO.md`: Task tracking template
  - `templates/MEMORY.md`: Project memory template
  - `templates/AGENT.md`: Development rules template
- `README.md`: Project description and overview
- `TODO.md`: Task tracking (template extraction task completed)
- `AGENT.md`: Development rules and guidelines
- `MEMORY.md`: This file - project state tracking

## Technical Details
- Uses bash RANDOM variable for random index generation
- Script can be sourced for function access or run directly for demonstration
- All tests passing with bats framework (16 tests total)
- Tests refactored for flexibility - focus on design requirements rather than implementation details
- `get_memorable_word()` returns one of 26 carefully selected memorable words
- `generate_folder_name()` uses last digit of year plus month (YMM format) with memorable word
- `create_project_directory()` creates directories and handles errors gracefully
- `generate_boilerplate_files()` copies template files to create README.md, TODO.md, MEMORY.md, and AGENT.md files (always uses AGENT.md template)
- `create_project_with_boilerplate()` combines directory creation with file generation
- Folder name format: YMM-memorableword (e.g., "506-lima" for June 2025)
- Script is executable with proper shebang line
- Boilerplate files include appropriate content templates for new projects
- AGENT.md is always created from the generalized template file for language-agnostic development guidelines
- Template files are stored in `templates/` directory for better maintainability
- AGENT.md template is generalized for any programming language/framework (not bash-specific)
- Boilerplate generation uses file copying from templates instead of heredocs
- Clean implementation focused on project initialization behavior
- Function names and comments focus on what they do, not how they do it
- Tests focus on behavioral requirements rather than implementation details
- Flexible design allows for future changes to word selection algorithm
- Directory creation includes error handling for existing directories
- Boilerplate generation includes error handling for non-existent directories and missing template files
- Functions return created directory name on success, error messages on failure
- Test suite designed to be flexible and focus on behavioral requirements rather than rigid implementation details

## Next Steps
Core folder name generation, directory creation, and template-based boilerplate file generation functionality is complete with brief YMM date format, behavioral function names and comprehensive tests. The project needs additional features to fulfill its goal as a project initializer:
- Git repository initialization functionality
- Main script logic to tie everything together
- Consider making the word selection algorithm configurable for different use cases
- Consider adding templates for different project types (templates directory makes this easier to extend)
- AGENT.md template provides comprehensive, language-agnostic development guidelines suitable for any project type
- Year digit extraction implemented using method 2 (parameter expansion with %Y) to get last digit of current year
- Date format changed from YYMM to YMM for more concise folder names while maintaining chronological sorting within decades