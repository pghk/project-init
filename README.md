# Project Initializer

This is a simple bash script called `project-init` for starting new development projects with proper boilerplate structure and git initialization.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/pghk/project-init.git
   cd project-init/init
   ```

2. **Make the script executable:**
   ```bash
   chmod +x project-init
   ```

3. **Install the script:**
   ```bash
   # Option A: System-wide installation (recommended)
   sudo ln -s "$(pwd)/project-init" /usr/local/bin/project-init
   
   # Option B: User installation
   mkdir -p ~/.local/bin
   ln -s "$(pwd)/project-init" ~/.local/bin/project-init
   # Add ~/.local/bin to your PATH if not already done
   ```

4. **Set up templates with symlinks (recommended for easy updates):**
   ```bash
   # Create config directory and symlink templates
   mkdir -p ~/.config/project-init/
   ln -s "$(pwd)/templates" ~/.config/project-init/templates
   ```

5. **Verify installation:**
   ```bash
   project-init --help
   ```

### Updating

To get the latest templates and features:
```bash
cd /path/to/project-init
git pull
```

Since templates are symlinked, updates are automatically available without reinstallation.

### Template Configuration

By default, `project-init` looks for templates in these locations (in order):
1. `$PROJECT_INIT_TEMPLATES` (environment variable)
2. `./templates` (current directory)
3. `~/.config/project-init/templates/`
4. `/usr/local/share/project-init/templates/`

To use custom templates:
```bash
# Set custom template directory
export PROJECT_INIT_TEMPLATES="/path/to/your/templates"

# Or copy templates to user config directory
mkdir -p ~/.config/project-init/templates/
cp templates/* ~/.config/project-init/templates/
```

## Usage

```bash
# Create project with auto-generated name
project-init

# Create project with custom name
project-init my-project-name

# Show help
project-init --help
```

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
