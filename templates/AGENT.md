# Agent Task Checklist

For every task assigned, complete these steps in order:

1. **Review Memory File** - Read and understand current project state and context
2. **Write Tests First** - Create comprehensive test cases (see implementation guide)
3. **Implement Code** - Write code to make the tests pass
4. **Run Tests** - Execute tests to verify functionality
5. **Update TODO List** - Mark the task as completed
6. **Update Memory File** - Record current project state and relevant notes
7. **Fix Issues** - Address any warnings or errors in the code
8. **Update Guidelines & Sync Templates** - Revise development guidelines and synchronize improvements to templates
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
- Choose appropriate testing framework for your language/technology stack
- Follow test-driven development (TDD) principles
- Write failing tests before implementing functionality

### Test Coverage Requirements
- Valid output verification
- Non-empty return values
- Multiple function calls
- Edge cases and boundary conditions
- Input validation and error handling
- Format validation where applicable
- Integration tests for complex workflows

## 3. Code Implementation

### Code Quality Standards
- Use consistent indentation and formatting
- Follow language-specific style guidelines and conventions
- Add comments for complex logic and business rules
- Validate inputs and handle edge cases gracefully
- Keep functions focused on single responsibilities
- Use meaningful function, variable, and class names
- Implement proper error handling and logging

### Performance Considerations
- Consider algorithmic complexity and optimization opportunities
- Prefer efficient data structures for the use case
- Avoid premature optimization, but be mindful of performance
- Profile and measure when performance is critical

### Architecture and Design
- Follow SOLID principles and other relevant design patterns
- Maintain separation of concerns
- Design for maintainability and extensibility
- Document architectural decisions and trade-offs

## 4. Running Tests

Execute your test suite to verify:
- All test cases pass
- Functions work as expected
- Edge cases are handled properly
- Output format is correct
- Error conditions are properly handled
- Integration points work correctly

## 5. Updating TODO List

- Mark completed tasks clearly
- Maintain task tracking accuracy
- Use TODO.md for centralized task management
- Break down large tasks into smaller, manageable items

## 6. Updating Memory File

### Memory File Rules
- Keep current with project state
- Include technical decisions and implementation details
- Do NOT annotate task completion (use TODO list instead)
- Document any important discoveries or patterns
- Record lessons learned and insights gained

## 7. Fixing Issues

- Address compiler/linter warnings and errors
- Resolve any failing tests
- Fix security vulnerabilities and code smells
- Ensure code quality standards are met
- Validate functionality after fixes

## 8. Updating Guidelines & Sync Templates

### Update Development Guidelines
Update development guidelines when you learn:
- New best practices
- Better implementation patterns
- Useful techniques or tools
- Important considerations for future work
- Language or framework-specific insights

### Documentation Structure Best Practices
When writing or updating project documentation:
- **Lead with project identity**: First paragraph should clearly state what the tool/project is and its primary purpose
- **Front-load key features**: Place design requirements and core capabilities prominently near the top, before installation details
- **Use progressive disclosure**: Structure information from most important (identity, purpose, key features) to implementation details (installation, configuration)
- **Focus on user value**: Emphasize what the tool does for users rather than how it works internally
- **Test documentation structure**: Include tests that verify documentation contains required sections and content in the correct order

### Template Synchronization
**Always check if guideline updates should be synchronized to templates:**
- **Core workflow changes** (steps 1-12, commit message format, project structure standards) → Synchronize to templates while keeping language-agnostic
- **Project-specific implementation details** → Keep only in project-specific guidelines
- **Language-agnostic best practices** (like documentation structure above) → Synchronize to templates
- Review templates after significant updates and commit template changes separately

## 9. Committing Changes

### Pre-Commit Cleanup
Before committing changes, ensure:
- Remove any temporary files or artifacts
- Clean up debugging code and console outputs
- Verify only intended files are being committed using version control status
- Run linters and formatters if available
- Ensure all tests pass

### Git Commit Message Format
1. **Subject Line** (≤ 50 characters)
   - Capitalize first word
   - No trailing period
   - Use imperative mood (e.g. "Add" not "Added")
   - Begin with appropriate emoji/prefix if using conventions

2. **Body** (optional)
   - Wrap at 72 characters
   - Explain *what* and *why*—not *how*
   - Separate from subject with blank line
   - Include references to issues or tickets if applicable

### Commit Message Conventions
Consider using conventional commits or gitmoji for consistent messaging:
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
- 🛂 Work on authentication/authorization
- 🩹 Simple, non-critical fix
- 💚 Fix CI build
- 🏗 Make architectural changes
- ♻️ Refactor code
- ➕ Add a dependency
- ➖ Remove a dependency
- 🔧 Add or update configuration files
- 🔨 Add or update development scripts
- ✏️ Fix typos
- ⏪️ Revert changes
- 🔀 Merge branches
- 📦 Add or update compiled files or packages
- 👷 Add or update CI build system
- 🧪 Add a failing test
- 🏷️ Add or update types
- 🌱 Add or update seed files
- 🚸 Improve UX/usability
- ♿️ Improve accessibility
- 💥 Introduce breaking changes
- 🚨 Fix compiler/linter warnings

---

# Project Structure Standards

- Use clear, descriptive file names following language conventions
- Organize files in logical directory structures
- Keep test files organized and easily discoverable
- Maintain memory file for project state tracking
- Use TODO.md for centralized task management
- Keep README.md updated with project overview and setup instructions
- Document technical decisions and implementation details
- Include usage examples and API documentation where helpful
- Follow language-specific project structure conventions