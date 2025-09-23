#!/bin/bash

# Unit Tests for Mini Project Application
# This script tests the main application functionality
# Author: DevOps Course
# Date: 2025-09-23

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Functions
function log() {
    echo -e "${GREEN}[TEST] $1${NC}"
}

function error() {
    echo -e "${RED}[FAIL] $1${NC}" >&2
}

function warning() {
    echo -e "${YELLOW}[WARN] $1${NC}"
}

function assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    ((TESTS_RUN++))

    if [ "$expected" = "$actual" ]; then
        log "PASS: $test_name"
        ((TESTS_PASSED++))
    else
        error "FAIL: $test_name"
        error "  Expected: '$expected'"
        error "  Actual: '$actual'"
        ((TESTS_FAILED++))
    fi
}

function assert_file_exists() {
    local file="$1"
    local test_name="$2"

    ((TESTS_RUN++))

    if [ -f "$file" ]; then
        log "PASS: $test_name"
        ((TESTS_PASSED++))
    else
        error "FAIL: $test_name - File '$file' does not exist"
        ((TESTS_FAILED++))
    fi
}

function test_version_output() {
    local output=$(bash src/app.sh version)
    local expected="Mini Project App v1.0.0"

    assert_equals "$expected" "$output" "Version command output"
}

function test_help_output() {
    local output=$(bash src/app.sh --help | head -1)
    local expected="Mini Project App v1.0.0"

    assert_equals "$expected" "$output" "Help command first line"
}

function test_status_when_not_running() {
    # Ensure app is not running
    rm -f app.pid

    local output=$(bash src/app.sh status)
    # Should contain "not running"
    if echo "$output" | grep -q "not running"; then
        log "PASS: Status shows not running when app is stopped"
        ((TESTS_PASSED++))
    else
        error "FAIL: Status should show 'not running' when app is stopped"
        error "  Output: '$output'"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

function test_test_mode() {
    local output=$(bash src/app.sh --test start 2>&1)
    local expected="Test mode: Simulating start"

    if echo "$output" | grep -q "$expected"; then
        log "PASS: Test mode works correctly"
        ((TESTS_PASSED++))
    else
        error "FAIL: Test mode not working"
        error "  Expected to find: '$expected'"
        error "  Output: '$output'"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

function test_unknown_command() {
    local exit_code=0
    local output=$(bash src/app.sh unknown 2>&1) || exit_code=$?

    if [ $exit_code -ne 0 ]; then
        log "PASS: Unknown command returns non-zero exit code"
        ((TESTS_PASSED++))
    else
        error "FAIL: Unknown command should return non-zero exit code"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

function test_app_file_exists() {
    assert_file_exists "src/app.sh" "Application file exists"
}

function test_script_syntax() {
    if bash -n src/app.sh; then
        log "PASS: Script syntax is valid"
        ((TESTS_PASSED++))
    else
        error "FAIL: Script has syntax errors"
        ((TESTS_FAILED++))
    fi
    ((TESTS_RUN++))
}

function show_test_summary() {
    echo ""
    echo "=== Test Summary ==="
    echo "Tests run: $TESTS_RUN"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        return 1
    fi
}

# Main execution
main() {
    log "Starting unit tests for Mini Project Application..."

    test_app_file_exists
    test_script_syntax
    test_version_output
    test_help_output
    test_status_when_not_running
    test_test_mode
    test_unknown_command

    show_test_summary
}

main "$@"