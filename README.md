# Project initializer

This is a simple bash script for starting new development projects.

## Design Requirements

- Generates folder names that are brief, memorable, unique, and chronologically sortable (within a known 10-year span, and month-level granularity)
- Populates the folder with boilerplate files to facilitate task-based development process:
  - README.md with project overview
  - TODO.md for task tracking and completion status
  - MEMORY.md for maintaining project state between development sessions
  - AGENT.md with development rules and guidelines
- Initializes a git repository in the folder with initial commit
