#!/bin/bash

# Sample Application for Mini Project
# A simple demonstration application
# Author: DevOps Course
# Date: 2025-09-23

set -e  # Exit on error
set -u  # Exit on undefined variable

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="Mini Project App"
APP_VERSION="1.0.0"

# Functions
function log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

function error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

function show_help() {
    cat << EOF
$APP_NAME v$APP_VERSION

Usage: $0 [OPTIONS] [COMMAND]

Commands:
    start       Start the application
    stop        Stop the application
    status      Show application status
    version     Show version information
    test        Run internal tests

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    --test          Run in test mode

Examples:
    $0 start
    $0 --verbose status
    $0 test

EOF
}

function show_version() {
    echo "$APP_NAME v$APP_VERSION"
    echo "Built on: $(date)"
}

function start_app() {
    log "Starting $APP_NAME..."

    # Simulate application startup
    echo -e "${BLUE}Application starting...${NC}"
    sleep 1

    # Create PID file
    echo $$ > app.pid

    log "$APP_NAME started successfully (PID: $$)"
    echo "Press Ctrl+C to stop"

    # Main application loop (simulated)
    trap 'stop_app' INT TERM
    while true; do
        echo -e "${BLUE}Application running... (Press Ctrl+C to stop)${NC}"
        sleep 5
    done
}

function stop_app() {
    log "Stopping $APP_NAME..."

    # Remove PID file
    rm -f app.pid

    log "$APP_NAME stopped"
    exit 0
}

function show_status() {
    if [ -f "app.pid" ]; then
        local pid=$(cat app.pid)
        if kill -0 "$pid" 2>/dev/null; then
            echo -e "${GREEN}$APP_NAME is running (PID: $pid)${NC}"
        else
            echo -e "${RED}$APP_NAME is not running (stale PID file)${NC}"
            rm -f app.pid
        fi
    else
        echo -e "${YELLOW}$APP_NAME is not running${NC}"
    fi
}

function run_internal_tests() {
    log "Running internal tests..."

    # Simulate some tests
    echo "Testing configuration..."
    sleep 0.5
    echo "Testing database connection..."
    sleep 0.5
    echo "Testing API endpoints..."
    sleep 0.5

    log "All internal tests passed"
}

# Parse command line arguments
VERBOSE=false
TEST_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --test)
            TEST_MODE=true
            shift
            ;;
        start|stop|status|version|test)
            COMMAND=$1
            shift
            break
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Default command
COMMAND=${COMMAND:-status}

# Execute command
case $COMMAND in
    start)
        if [ "$TEST_MODE" = true ]; then
            log "Test mode: Simulating start"
            exit 0
        fi
        start_app
        ;;
    stop)
        stop_app
        ;;
    status)
        show_status
        ;;
    version)
        show_version
        ;;
    test)
        run_internal_tests
        ;;
    *)
        error "Unknown command: $COMMAND"
        show_help
        exit 1
        ;;
esac