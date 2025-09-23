#!/bin/bash

# Setup Script for Mini Project
# This script initializes the project environment
# Author: DevOps Course
# Date: 2025-09-23

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
function log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

function error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

function warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

function check_dependencies() {
    log "Checking dependencies..."

    # Check if git is installed
    if ! command -v git >/dev/null 2>&1; then
        error "Git is required but not installed. Please install Git first."
        exit 1
    fi

    # Check if bash is available
    if ! command -v bash >/dev/null 2>&1; then
        error "Bash is required but not available."
        exit 1
    fi

    log "All dependencies are available"
}

function create_directories() {
    log "Creating project directories..."

    # Directories should already exist, but let's ensure they do
    mkdir -p scripts src tests docs

    # Create additional directories if needed
    mkdir -p logs backups

    log "Directories created successfully"
}

function initialize_git() {
    log "Initializing Git repository..."

    if [ ! -d ".git" ]; then
        git init
        log "Git repository initialized"
    else
        warning "Git repository already exists"
    fi

    # Create .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        cat > .gitignore << EOF
# Logs
logs/
*.log

# Backups
backups/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Temporary files
*.tmp
*.temp
EOF
        log ".gitignore file created"
    fi
}

function set_permissions() {
    log "Setting script permissions..."

    # Make all scripts in scripts directory executable
    find scripts/ -name "*.sh" -type f -exec chmod +x {} \;

    log "Permissions set successfully"
}

# Main execution
main() {
    log "Starting project setup..."

    check_dependencies
    create_directories
    initialize_git
    set_permissions

    log "Project setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Review and customize the scripts in the 'scripts/' directory"
    echo "2. Add your application code to 'src/'"
    echo "3. Write tests in 'tests/'"
    echo "4. Run 'scripts/build.sh' to build the project"
    echo "5. Run 'scripts/test.sh' to test the project"
    echo "6. Run 'scripts/deploy.sh' to deploy the project"
}

main "$@"