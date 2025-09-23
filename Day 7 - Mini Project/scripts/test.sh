#!/bin/bash

# Test Script for Mini Project
# This script runs automated tests
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

function run_unit_tests() {
    log "Running unit tests..."

    if [ -f "tests/test_app.sh" ]; then
        if bash tests/test_app.sh; then
            log "Unit tests passed"
        else
            error "Unit tests failed"
            exit 1
        fi
    else
        warning "No unit tests found (tests/test_app.sh)"
    fi
}

function run_integration_tests() {
    log "Running integration tests..."

    # Test if the built application works
    if [ -f "build/app.sh" ]; then
        if timeout 10s bash build/app.sh --test >/dev/null 2>&1; then
            log "Integration tests passed"
        else
            error "Integration tests failed"
            exit 1
        fi
    else
        warning "Built application not found. Run build.sh first."
    fi
}

function check_code_quality() {
    log "Checking code quality..."

    # Check for common issues
    local issues=0

    # Check for TODO comments
    if grep -r "TODO" src/ scripts/ 2>/dev/null; then
        warning "Found TODO comments in code"
        ((issues++))
    fi

    # Check for hardcoded paths
    if grep -r "/hardcoded/path" src/ scripts/ 2>/dev/null; then
        warning "Found hardcoded paths"
        ((issues++))
    fi

    # Check for long lines (>100 characters)
    if find src/ scripts/ -name "*.sh" -exec grep -l '.\{101\}' {} \; 2>/dev/null | grep -q .; then
        warning "Found lines longer than 100 characters"
        ((issues++))
    fi

    if [ $issues -eq 0 ]; then
        log "Code quality checks passed"
    else
        warning "Found $issues code quality issues"
    fi
}

function generate_test_report() {
    log "Generating test report..."

    mkdir -p reports

    cat > reports/test_report.txt << EOF
Test Report - $(date)

Unit Tests: $([ -f "tests/test_app.sh" ] && echo "Present" || echo "Missing")
Integration Tests: $([ -f "build/app.sh" ] && echo "Passed" || echo "Failed - Build not found")
Code Quality: Checked

For detailed results, check the console output above.
EOF

    log "Test report generated: reports/test_report.txt"
}

# Main execution
main() {
    log "Starting test suite..."

    run_unit_tests
    run_integration_tests
    check_code_quality
    generate_test_report

    log "All tests completed!"
}

main "$@"