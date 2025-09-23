# Day 7: Mini Project - Git Repository + Bash Script Automation

## Overview
In this mini project, you'll combine your knowledge of Git and Bash scripting to create an automated workflow. You'll set up a Git repository and write Bash scripts to automate common DevOps tasks.

## Project Goals
- Create a Git repository structure for a simple project
- Write Bash scripts for automation tasks
- Implement version control best practices
- Demonstrate CI/CD concepts using scripts

## Project Structure
```
mini-project/
├── scripts/
│   ├── setup.sh
│   ├── build.sh
│   ├── test.sh
│   └── deploy.sh
├── src/
│   └── app.sh
├── tests/
│   └── test_app.sh
├── docs/
│   └── README.md
├── .gitignore
├── LICENSE
└── README.md
```

## Tasks

### 1. Repository Setup
Create a new Git repository and initialize the project structure above.

### 2. Bash Scripts
Write the following Bash scripts in the `scripts/` directory:

#### `setup.sh`
- Initialize the project environment
- Install dependencies (if any)
- Set up necessary directories

#### `build.sh`
- Compile or prepare the application for deployment
- Validate code syntax
- Create build artifacts

#### `test.sh`
- Run automated tests
- Check code quality
- Validate configurations

#### `deploy.sh`
- Simulate deployment to a staging environment
- Create backups
- Update version numbers

### 3. Main Application
Create a simple Bash application in `src/app.sh` that demonstrates basic functionality.

### 4. Testing
Write basic tests in `tests/test_app.sh` to validate your application.

### 5. Documentation
- Update the main `README.md` with project description and usage instructions
- Document each script's purpose and usage

## Requirements
- All scripts must be executable (`chmod +x`)
- Include proper error handling
- Use functions for reusable code
- Add comments explaining complex logic
- Follow Bash best practices

## Git Workflow
1. Initialize repository
2. Create feature branches for each script
3. Commit changes with meaningful messages
4. Merge to main branch
5. Tag releases

## Example Script Structure
```bash
#!/bin/bash

# Script header with description
# Author: Your Name
# Date: YYYY-MM-DD

set -e  # Exit on error
set -u  # Exit on undefined variable

# Functions
function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function check_dependencies() {
    # Check if required tools are installed
    command -v git >/dev/null 2>&1 || { echo "Git is required but not installed."; exit 1; }
}

# Main execution
main() {
    log "Starting setup..."
    check_dependencies
    # Your code here
    log "Setup completed successfully"
}

main "$@"
```

## Bonus Challenges
- Add Git hooks for pre-commit validation
- Implement logging to files
- Add configuration files for different environments
- Create a master script that runs all automation steps

## Learning Outcomes
By completing this project, you'll learn:
- How to structure a Git repository for automation
- Bash scripting best practices
- Basic CI/CD concepts
- Version control workflows
- Documentation practices

## Next Steps
After completing this project, you'll be ready to dive into containerization with Docker in the next module.