#!/bin/bash

# Build Script for Mini Project
# This script builds the application
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

function validate_scripts() {
    log "Validating scripts..."

    # Check if main application script exists
    if [ ! -f "src/app.sh" ]; then
        error "Main application script 'src/app.sh' not found"
        exit 1
    fi

    # Validate bash syntax
    if ! bash -n src/app.sh; then
        error "Syntax error in src/app.sh"
        exit 1
    fi

    log "Script validation passed"
}

function create_build_artifacts() {
    log "Creating build artifacts..."

    # Create build directory
    mkdir -p build

    # Copy application to build directory
    cp src/app.sh build/

    # Make executable
    chmod +x build/app.sh

    # Create version file
    echo "Build Date: $(date)" > build/version.txt
    echo "Git Commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'Not a git repository')" >> build/version.txt

    log "Build artifacts created in 'build/' directory"
}

function run_syntax_check() {
    log "Running syntax checks..."

    # Check all bash scripts in the project
    find . -name "*.sh" -type f -exec bash -n {} \;

    log "Syntax checks passed"
}

# Main execution
main() {
    log "Starting build process..."

    validate_scripts
    run_syntax_check
    create_build_artifacts

    log "Build completed successfully!"
    echo ""
    echo "Build artifacts available in 'build/' directory"
    echo "Run 'build/app.sh' to test the built application"
}

main "$@"