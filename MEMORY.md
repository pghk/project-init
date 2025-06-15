# Project Memory

## Current State
This is a bash project initializer that creates new development projects with boilerplate files.

## Implemented Features
- `get_memorable_word()` function that returns a random memorable word for folder naming
- `generate_folder_name()` function that creates unique folder names with brief date (YMM) and memorable word
- `create_project_directory()` function that creates project directories with generated or specified names
- `generate_boilerplate_files()` function that creates standard project files from templates in a directory (treats all template files uniformly)
- `create_project_with_boilerplate()` function that creates directories and populates them with boilerplate files
- `initialize_git_repository()` function that initializes git repositories with initial commits
- `create_project_with_git()` function that creates complete project setup with directory, boilerplate files, and git repository
- `main()` function that handles command-line interface and script execution
- `show_help()` function that displays comprehensive usage information
- Complete command-line interface with argument parsing and error handling
- Initial git commit functionality that creates commits with all boilerplate files
- Memorable words array with 26 carefully selected words (alpha through zulu)
- Comprehensive test suite using bats framework with 36 flexible test cases:
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
  - Tests appropriate AGENT.md file generation (now handled uniformly with other templates)
  - Tests integrated project creation with boilerplate files
  - Tests project creation with specified directory names
  - Tests git repository initialization in existing directories
  - Tests error handling for git initialization in non-existent directories
  - Tests graceful handling of existing git repositories
  - Tests complete project creation with git repository initialization
  - Tests project creation with git using specified directory names
  - Tests main script execution with no arguments (automatic name generation)
  - Tests main script execution with specified directory names
  - Tests help information display for various help flags
  - Tests invalid argument handling with appropriate error messages
  - Tests meaningful error messages for directory creation failures
  - Tests informative success messages for project creation
  - Tests core functionality demonstration when run without arguments
  - Tests script executable permissions and proper shebang line
  - Tests direct script execution without bash invocation
  - Tests git repository initialization with initial commit
  - Tests appropriate commit messages for initial commits
  - Tests that all boilerplate files are included in initial commit
  - Tests graceful handling of existing git repositories with new commits
  - Tests main script creates projects with initial commits

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
- Script can be sourced for function access or run directly as command-line tool
- All tests passing with bats framework (36 tests total)
- Tests refactored for flexibility - focus on design requirements rather than implementation details
- Complete command-line interface with help system and error handling
- Main script logic handles 0-1 arguments with comprehensive validation
- Script has proper executable permissions and shebang line for command-line use
- `get_memorable_word()` returns one of 26 carefully selected memorable words
- `generate_folder_name()` uses last digit of year plus month (YMM format) with memorable word
- `create_project_directory()` creates directories and handles errors gracefully
- `generate_boilerplate_files()` copies template files to create README.md, TODO.md, MEMORY.md, and AGENT.md files (all templates handled uniformly)
- `create_project_with_boilerplate()` combines directory creation with file generation
- `initialize_git_repository()` initializes git repositories with proper error handling
- `create_project_with_git()` provides complete project setup including git repository initialization
- Folder name format: YMM-memorableword (e.g., "506-lima" for June 2025)
- Script is executable with proper shebang line
- Boilerplate files include appropriate content templates for new projects
- AGENT.md is created from the generalized template file for language-agnostic development guidelines (handled uniformly with other templates)
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
- Git initialization uses `git init --quiet` for clean operation
- Git functions handle non-existent directories and existing repositories gracefully
- Complete project creation now includes git repository initialization with initial commit by default
- Git initialization includes automatic user configuration for commits
- Initial commits include all boilerplate files with descriptive commit message using gitmoji
- Git functions handle existing repositories by adding new files and creating additional commits
- Test suite designed to be flexible and focus on behavioral requirements rather than rigid implementation details
- Command-line interface supports help flags (--help, -h, help) with comprehensive usage information
- Main function provides informative output and proper exit codes
- Error handling includes meaningful messages for common failure scenarios
- Script demonstrates core functionality when run without arguments
- Proper argument validation with usage display for invalid inputs
- Script executable as standalone command-line tool without requiring bash invocation

## Project Complete
All design requirements have been successfully implemented. The project initializer is now a complete, fully functional command-line tool that meets all specified requirements:

### Completed Features
- ✅ Generates brief, memorable, unique, chronologically sortable folder names (YMM-word format)
- ✅ Supports both auto-generated and user-specified directory names
- ✅ Creates complete boilerplate file structure (README.md, TODO.md, MEMORY.md, AGENT.md)
- ✅ Initializes git repository with initial commit containing all boilerplate files
- ✅ Full command-line interface with help system and error handling
- ✅ Executable as standalone tool with proper permissions and shebang
- ✅ Comprehensive test suite with 36 test cases covering all functionality
- ✅ Language-agnostic AGENT.md template for development guidelines

### Design Requirements Fulfilled
All design requirements from README.md have been completely implemented:
1. ✅ Brief, memorable, unique, chronologically sortable folder names
2. ✅ Support for both auto-generated and user-specified names
3. ✅ Complete boilerplate file population
4. ✅ Git repository initialization with initial commit

Future enhancements could include:
- Making the word selection algorithm configurable for different use cases
- Adding templates for different project types

### Technical Excellence
- Robust error handling with meaningful user feedback
- Flexible test suite focused on behavioral requirements
- Clean, maintainable code with proper separation of concerns
- Template-based file generation for easy extensibility
- Graceful handling of edge cases and existing repositories

The project is ready for production use as a complete project initializer tool.
