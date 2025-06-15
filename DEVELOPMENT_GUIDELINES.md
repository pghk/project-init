# Development Guidelines

## Project Structure
- Use clear, descriptive file names
- Keep test files alongside source files for easy access
- Maintain a memory file to track project state between development sessions
- Use TODO.md for task tracking and completion status

## Testing Strategy
- Use bats framework for bash script testing
- Write comprehensive test cases that cover:
  - Valid output verification
  - Non-empty return values
  - Multiple function calls
  - Edge cases and boundary conditions
- Always run tests with `bats test.sh` before committing
- Source scripts in tests to access functions: `source script.sh`

## Bash Scripting Best Practices
- Use arrays for related data (e.g., NATO_WORDS array)
- Implement proper random selection with `RANDOM % array_length`
- Support both sourcing and direct execution patterns
- Use meaningful variable names and local scope where appropriate
- Add shebang lines for proper script execution

## Git Workflow
- Initialize git repository at project start
- Write descriptive commit messages with:
  - Brief summary in first line
  - Detailed explanation of changes
  - List of specific implementations
- Commit after each completed task with passing tests

## Task-Based Development Process
1. Write comprehensive tests first
2. Implement code to make tests pass
3. Run tests to verify functionality
4. Update TODO list to mark completion
5. Update memory file with current state
6. Check for and fix any warnings/errors
7. Commit changes with descriptive message
8. Update development guidelines if needed

## Code Quality
- Use consistent indentation and formatting
- Add comments for complex logic
- Validate inputs and handle edge cases
- Keep functions focused on single responsibilities
- Use meaningful function and variable names

## Documentation
- Keep README.md updated with project overview
- Maintain MEMORY.md with current project state
- Document technical decisions and implementation details
- Include usage examples where helpful