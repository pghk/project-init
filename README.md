# Project Initializer

This is a simple bash script for starting new development projects.

## Design Requirements

- Generates folder names that are brief, memorable, unique, and chronologically sortable (within a known 10-year span, and month-level granularity)
- Supports both auto-generated folder names and user-specified directory names
- Populates the folder with boilerplate files to facilitate task-based development process:
  - README.md with project overview
  - TODO.md for task tracking and completion status
  - MEMORY.md for maintaining project state between development sessions
  - AGENT.md with development rules and guidelines
- Initializes a git repository in the folder with initial commit

## Acknowledgements
- Made with [Zed](https://zed.dev/) and [Claude Sonnet 4](https://www.anthropic.com/claude/sonnet)
- Agentic workflow inspired by [John Davenport](https://generaitelabs.com/one-agentic-coding-workflow-to-rule-them-all/)
