#!/bin/bash

# Deploy Script for Mini Project
# This script simulates deployment to staging environment
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

function create_backup() {
    log "Creating backup..."

    mkdir -p backups

    local backup_file="backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz"

    # Backup current deployment if it exists
    if [ -d "staging" ]; then
        tar -czf "$backup_file" staging/
        log "Backup created: $backup_file"
    else
        log "No existing deployment to backup"
    fi
}

function prepare_staging() {
    log "Preparing staging environment..."

    # Create staging directory
    rm -rf staging
    mkdir -p staging

    # Copy build artifacts to staging
    if [ -d "build" ]; then
        cp -r build/* staging/
        log "Build artifacts copied to staging"
    else
        error "Build directory not found. Run build.sh first."
        exit 1
    fi
}

function deploy_application() {
    log "Deploying application..."

    # Simulate deployment steps
    cd staging

    # Make sure the app is executable
    chmod +x app.sh

    # Create a simple deployment marker
    echo "Deployed on: $(date)" > deployment_info.txt
    echo "Version: $(cat version.txt)" >> deployment_info.txt

    cd ..

    log "Application deployed to staging environment"
}

function run_smoke_tests() {
    log "Running smoke tests..."

    # Quick test to ensure deployment works
    if [ -f "staging/app.sh" ]; then
        if timeout 5s bash staging/app.sh --version >/dev/null 2>&1; then
            log "Smoke tests passed"
        else
            error "Smoke tests failed"
            exit 1
        fi
    else
        error "Application not found in staging"
        exit 1
    fi
}

function update_version() {
    log "Updating version..."

    # Simple version increment (for demonstration)
    local version_file="version.txt"
    local new_version="1.0.$(date +%s)"

    echo "$new_version" > "$version_file"

    log "Version updated to $new_version"
}

function cleanup_old_backups() {
    log "Cleaning up old backups..."

    # Keep only last 5 backups
    ls -t backups/backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm

    log "Old backups cleaned up"
}

# Main execution
main() {
    log "Starting deployment process..."

    create_backup
    prepare_staging
    deploy_application
    run_smoke_tests
    update_version
    cleanup_old_backups

    log "Deployment completed successfully!"
    echo ""
    echo "Application deployed to 'staging/' directory"
    echo "Run 'staging/app.sh' to start the application"
    echo "Check 'staging/deployment_info.txt' for deployment details"
}

main "$@"