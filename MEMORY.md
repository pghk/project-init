# Project Memory

## Current State
This is a bash project initializer that creates new development projects with boilerplate files.

## Implemented Features
- `get_memorable_word()` function that returns a random memorable word for folder naming
- `generate_folder_name()` function that creates unique folder names with brief date (YMM) and memorable word
- Memorable words array with 26 carefully selected words (alpha through zulu)
- Flexible test suite using bats framework with 4 behavioral test cases:
  - Validates properly formatted folder names (date-word with dash separator)
  - Tests chronologically sortable date format (YMM)
  - Validates memorable words (lowercase, filesystem-safe, appropriate length)
  - Tests folder name uniqueness and randomness over multiple calls

## Project Structure
- `script.sh`: Main bash script with NATO alphabet functionality
- `test.sh`: Bats test framework file with comprehensive tests
- `README.md`: Project description and overview
- `TODO.md`: Task tracking (NATO alphabet task completed)
- `AGENT.md`: Development rules and guidelines
- `MEMORY.md`: This file - project state tracking

## Technical Details
- Uses bash RANDOM variable for random index generation
- Script can be sourced for function access or run directly for demonstration
- All tests passing with bats framework
- `get_memorable_word()` returns one of 26 carefully selected memorable words
- `generate_folder_name()` uses `date +%y%m` for brief date format with memorable word
- Folder name format: YMM-memorableword (e.g., "2406-lima")
- Script is executable with proper shebang line
- Clean implementation focused on folder name generation behavior
- Function names and comments focus on what they do, not how they do it
- Tests focus on behavioral requirements rather than implementation details
- Flexible design allows for future changes to word selection algorithm

## Next Steps
Core folder name generation functionality is complete with brief YMM date format, behavioral function names and flexible tests. The project needs additional features to fulfill its goal as a project initializer:
- Function to create project directories with generated names
- Functions to populate directories with boilerplate files (README.md, TODO.md, MEMORY.md, AGENT.md)
- Git repository initialization functionality
- Main script logic to tie everything together
- Consider making the word selection algorithm configurable for different use cases