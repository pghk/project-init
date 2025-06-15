# Project Initializer

This is a simple bash script called `project-init` for starting new development projects with proper boilerplate structure and git initialization.

## Installation

### Quick Install (Recommended)

Download and install the latest version:

```bash
# Download the script
curl -O https://raw.githubusercontent.com/yourusername/project-init/main/project-init

# Make it executable
chmod +x project-init

# Move to a directory in your PATH
sudo mv project-init /usr/local/bin/

# Verify installation
project-init --help
```

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/project-init.git
   cd project-init/init
   ```

2. Make the script executable:
   ```bash
   chmod +x project-init
   ```

3. (Optional) Add to your PATH:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   export PATH="$PATH:/path/to/project-init/init"
   
   # Or create a symlink
   sudo ln -s /path/to/project-init/init/project-init /usr/local/bin/project-init
   ```

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
