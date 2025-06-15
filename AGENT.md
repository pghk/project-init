# General Development Rules

You should do task-based development. For every task, you should write the tests, implement the code, and run the tests to make sure everything works. Use `bats test.sh` to run the tests.

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
  - Format validation (separators, case sensitivity, etc.)
- Always run tests with `bats test.sh` before committing
- Source scripts in tests to access functions: `source script.sh`
- Use portable string manipulation methods for cross-platform compatibility:
  - Prefer `awk` over bash parameter expansion for case conversion
  - Use `tr` for reliable case transformation
  - Test string manipulation logic before implementing in tests

## Bash Scripting Best Practices
- Use arrays for related data (e.g., NATO_WORDS array)
- Implement proper random selection with `RANDOM % array_length`
- Support both sourcing and direct execution patterns
- Use meaningful variable names and local scope where appropriate
- Add shebang lines for proper script execution

## Git Workflow
- Initialize git repository at project start
- Write descriptive commit messages with:
  1. Split subject and body with a single blank line.
  2. Subject line
     - ≤ 50 characters
     - Capitalize first word
     - No trailing period
     - Use imperative mood (e.g. “Refactor” not “Refactored”)
  3. Body (optional)
     - Wrap at 72 characters
     - Explain *what* and *why*—not *how*
- Begin each commit message with an appropriate Gitmoji (listed in reference section)
- Commit after each completed task with passing tests

## Task-Based Development Process
1. Write comprehensive tests first
2. Implement code to make tests pass
3. Run tests to verify functionality
4. Update TODO list to mark completion
5. Update memory file with current state
6. Check for and fix any warnings/errors
7. Update development guidelines if needed
8. Commit changes with descriptive message

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

## Reference

### Gitmoji
This is a list of all Gitmoji entries from gitmoji.dev. Each item is a rule mapping the emoji to its meaning:

- 🎨 Improve structure/format of the code
- ⚡️ Improve performance
- 🔥 Remove code or files
- 🐛 Fix a bug
- 🚑 Critical hotfix
- ✨ Introduce new features
- 📝 Add or update documentation
- 🚀 Deploy stuff
- 💄 Add or update the UI and style files
- 🎉 Begin a project
- ✅ Add or update tests
- 🔒 Fix security issues
- 🍎 Fix Apple‐specific issues
- 🐧 Fix Linux‐specific issues
- 🏁 Fix Windows‐specific issues
- 🍏 Fix macOS‐specific issues
- 🐳 Fix Docker‐specific issues
- 🛂 Work on authentication/authorization
- 🩹 Simple, non-critical fix
- 💚 Fix CI build
- 🍙 Add or update assets
- 🏗 Make architectural changes
- 📈 Add or update analytics/tracking code
- ♻️ Refactor code
- ➕ Add a dependency
- ➖ Remove a dependency
- 🔧 Add or update configuration files
- 🔨 Add or update development scripts
- 🌐 Internationalization/localization
- ✏️ Fix typos
- 💩 Write bad code that needs improvement
- ⏪️ Revert changes
- 🔀 Merge branches
- 📦 Add or update compiled files or packages
- 👷 Add or update CI build system
- 🧪 Add a failing test
- 🏷️ Add or update types (Flow, TS, etc.)
- 🌱 Add or update seed files
- 🚸 Improve UX/usability
- ♿️ Improve accessibility
- 💥 Introduce breaking changes
- 🚨 Fix compiler/linter warnings
- 🩺 Add or update health check
- 💫 Add or update animations/transitions
- 🗃️ Perform database-related changes
- 🔍 Improve SEO
- 🧱 Infrastructure/housekeeping
- 🛠️ Add or update DevOps scripts
- 🗑️ Deprecate code to be removed
- 🧑‍💻 Improve developer experience
- 👥 Add or update user permissions
- 🚦 Add or update feature‐flag code
- 🧵 Add or update multithreading code
- 🔇 Remove logs
- 🔈 Add logs
- 🧮 Add or update calculation code
- 🧹 Content cleanup
- 🧼 Update code after security review
- 🦺 Add or update environment variables
- 🪛 Add or update CI/CD tools
- 🪄 Add or update reproducible scripts
