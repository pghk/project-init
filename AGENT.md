# Agent Task Checklist

For every task assigned, complete these steps in order:

1. **Review Memory File** - Read and understand current project state and context
2. **Write Tests First** - Create comprehensive test cases (see implementation guide)
3. **Implement Code** - Write code to make the tests pass
4. **Run Tests** - Execute tests to verify functionality
5. **Update TODO List** - Mark the task as completed
6. **Update Memory File** - Record current project state and relevant notes
7. **Fix Issues** - Address any warnings or errors in the code
8. **Update Guidelines** - Revise development guidelines based on learnings
9. **Commit Changes** - Use descriptive commit message (see implementation guide)
10. **Stop** - End session to open new chat for next task

---

# Detailed Implementation Guide

## 1. Reviewing Memory File

### Memory File Purpose
- Track project state between development sessions
- Store relevant notes and context
- Maintain continuity across chat sessions

### Review Process
- Read the memory file to understand current project state
- Note any technical decisions and implementation details
- Identify any important discoveries or patterns from previous work
- Use this context to inform your approach to the current task

## 2. Writing Tests First

### Testing Framework
- Use bats framework for bash script testing
- Run tests with `bats test.sh`
- Source scripts in tests to access functions: `source script.sh`

### Test Coverage Requirements
- Valid output verification
- Non-empty return values
- Multiple function calls
- Edge cases and boundary conditions
- Format validation (separators, case sensitivity, etc.)

## 3. Code Implementation

### Bash Scripting Standards
- Use arrays for related data (e.g., NATO_WORDS array)
- Implement proper random selection with `RANDOM % array_length`
- Support both sourcing and direct execution patterns
- Use meaningful variable names and local scope where appropriate
- Add shebang lines for proper script execution

### Performance Considerations
- Consider hardcoded data arrays over runtime string manipulation
- Prefer direct data access over transformation operations
- Create separate arrays for different data formats rather than converting at runtime

### Code Quality Standards
- Use consistent indentation and formatting
- Add comments for complex logic
- Validate inputs and handle edge cases
- Keep functions focused on single responsibilities
- Use meaningful function and variable names

### Template Management
- Store boilerplate templates in a dedicated `templates/` directory
- Use template files instead of heredocs for better maintainability
- Validate template file existence before copying
- Copy template files rather than using string concatenation for better performance
- Keep templates simple and focused - avoid complex logic in template content

## 4. Running Tests

Always execute `bats test.sh` to verify:
- All test cases pass
- Functions work as expected
- Edge cases are handled properly
- Output format is correct

## 5. Updating TODO List

- Mark completed tasks clearly
- Maintain task tracking accuracy
- Use TODO.md for centralized task management

## 6. Updating Memory File

### Memory File Rules
- Keep current with project state
- Include technical decisions and implementation details
- Do NOT annotate task completion (use TODO list instead)
- Document any important discoveries or patterns

## 7. Fixing Issues

- Address compiler/linter warnings
- Resolve any errors in the code
- Ensure code quality standards are met
- Validate functionality after fixes

## 8. Updating Guidelines

Update development guidelines when you learn:
- New best practices
- Better implementation patterns
- Useful techniques or tools
- Important considerations for future work

## 9. Committing Changes

### Pre-Commit Cleanup
Before committing changes, ensure:
- Remove any temporary test directories created during development
- Clean up any temporary files or artifacts
- Verify only intended files are being committed using `git status`
- Use `git add` selectively to avoid committing unwanted files

### Git Commit Message Format
1. **Subject Line** (≤ 50 characters)
   - Capitalize first word
   - No trailing period
   - Use imperative mood (e.g. "Refactor" not "Refactored")
   - Begin with appropriate Gitmoji

2. **Body** (optional)
   - Wrap at 72 characters
   - Explain *what* and *why*—not *how*
   - Separate from subject with blank line

### Gitmoji Reference
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

---

# Project Structure Standards

- Use clear, descriptive file names
- Keep test files alongside source files for easy access
- Maintain memory file for project state tracking
- Use TODO.md for centralized task management
- Keep README.md updated with project overview
- Document technical decisions and implementation details
- Include usage examples where helpful