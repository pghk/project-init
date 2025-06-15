# Project Memory

## Current State
This is a bash project initializer that creates new development projects with boilerplate files.

## Implemented Features
- `get_lowercase_nato_word()` function that returns a random lowercase NATO alphabet word
- `get_date_nato()` function that concatenates a brief date string (YYYYMMDD format) with a lowercase NATO word
- Lowercase NATO alphabet array with all 26 code words (alpha through zulu)
- Flexible test suite using bats framework with 4 behavioral test cases:
  - Validates properly formatted folder names (date-word with dash separator)
  - Tests chronologically sortable date format (YYYYMMDD)
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
- `get_lowercase_nato_word()` returns one of 26 valid lowercase NATO phonetic alphabet words
- `get_date_nato()` uses `date +%Y%m%d` for brief date format and hardcoded lowercase NATO array
- Date-nato format: YYYYMMDD-lowercasenato (e.g., "20250614-lima")
- Script is executable with proper shebang line
- Clean implementation with only necessary code for folder name generation
- Removed extraneous proper-case NATO functionality not needed for project initializer
- Tests focus on behavioral requirements rather than implementation details
- Flexible testing allows for future changes to word selection algorithm

## Next Steps
Core folder name generation functionality is complete with flexible, behavior-focused tests. The project needs additional features to fulfill its goal as a project initializer:
- Function to create project directories with generated names
- Functions to populate directories with boilerplate files (README.md, TODO.md, MEMORY.md, AGENT.md)
- Git repository initialization functionality
- Main script logic to tie everything together