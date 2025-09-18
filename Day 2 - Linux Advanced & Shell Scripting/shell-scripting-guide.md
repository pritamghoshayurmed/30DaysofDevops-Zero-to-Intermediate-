# Comprehensive Shell Scripting Guide

## Table of Contents
1. [Introduction to Shell Scripting](#introduction-to-shell-scripting)
2. [Shell Environment and Types](#shell-environment-and-types)
3. [Getting Started](#getting-started)
4. [Variables and Data Types](#variables-and-data-types)
5. [User Input and Output](#user-input-and-output)
6. [Command Line Arguments](#command-line-arguments)
7. [Conditional Statements](#conditional-statements)
8. [Loops](#loops)
9. [Functions](#functions)
10. [Arrays](#arrays)
11. [String Manipulation](#string-manipulation)
12. [File Operations](#file-operations)
13. [Process Management](#process-management)
14. [Error Handling](#error-handling)
15. [Advanced Techniques](#advanced-techniques)
16. [Debugging](#debugging)
17. [Best Practices](#best-practices)
18. [Real-World Examples](#real-world-examples)

## Introduction to Shell Scripting

A shell script is a command-line program that contains a series of commands for a computer to execute. It can be used to automate repetitive tasks, making your workflow more efficient. Shell scripts are written in a scripting language that is interpreted by a shell, such as Bash (Bourne Again SHell), which is the default shell for most Linux distributions.

### What is a Shell?

A shell is a command-line interface that acts as an intermediary between the user and the operating system kernel. It interprets commands entered by the user and executes them. The shell provides features like:

- **Command execution**
- **Variable management**
- **Control structures** (loops, conditionals)
- **I/O redirection**
- **Process management**
- **Scripting capabilities**

### Why Use Shell Scripting?

- **Automation:** Automate repetitive tasks, such as backups, system monitoring, and file management
- **System Administration:** Manage users, processes, and system configurations
- **DevOps Operations:** Deployment scripts, CI/CD pipelines, infrastructure management
- **Data Processing:** Text manipulation, log analysis, report generation
- **Customization:** Create custom commands and workflows tailored to your specific needs
- **Efficiency:** Execute a series of commands with a single script, saving time and effort
- **Portability:** Scripts can run on different Unix-like systems with minimal changes

### Common Use Cases

- **System backups and maintenance**
- **Log rotation and cleanup**
- **User account management**
- **Application deployment**
- **Monitoring and alerting**
- **Data migration**
- **Environment setup**

## Shell Environment and Types

### Popular Shell Types

1. **Bash (Bourne Again SHell)** - Most common, default on most Linux distributions
2. **Zsh (Z Shell)** - Feature-rich with advanced completion and customization
3. **Fish (Friendly Interactive SHell)** - User-friendly with syntax highlighting
4. **Dash** - Lightweight, POSIX-compliant shell
5. **Ksh (Korn Shell)** - Combines features of Bourne and C shells

### Checking Your Shell

```bash
# Check current shell
echo $SHELL

# List available shells
cat /etc/shells

# Check shell version
bash --version
```

### Shell Options and Settings

```bash
# Enable debugging
set -x

# Exit on any error
set -e

# Exit on undefined variables
set -u

# Fail on pipe errors
set -o pipefail

# Combine common options
set -euo pipefail
```

## Getting Started

### Creating a Shell Script

To create a shell script, you need to create a new file with a `.sh` extension. For example, `my_script.sh`.

The first line of a shell script should be the "shebang" line, which specifies the interpreter to be used:

```bash
#!/bin/bash          # Use bash
#!/usr/bin/env bash  # Use bash from PATH (more portable)
#!/bin/sh            # Use system default shell
#!/usr/bin/env python3  # For Python scripts
```

### Script Structure

```bash
#!/bin/bash

# Script metadata
# Name: example_script.sh
# Purpose: Demonstrate shell scripting concepts
# Author: Your Name
# Date: 2025-09-18
# Version: 1.0

# Set script options
set -euo pipefail

# Global variables
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"

# Main script logic goes here
main() {
    echo "Hello from $SCRIPT_NAME"
}

# Call main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### Making the Script Executable

Before you can run a shell script, you need to make it executable:

```bash
# Make executable for owner only
chmod u+x my_script.sh

# Make executable for everyone
chmod +x my_script.sh

# More specific permissions (read, write, execute for owner; read, execute for others)
chmod 755 my_script.sh
```

### Running a Shell Script

There are several ways to execute a shell script:

```bash
# Method 1: Execute directly (requires execute permission)
./my_script.sh

# Method 2: Run with bash explicitly
bash my_script.sh

# Method 3: Source the script (runs in current shell)
source my_script.sh
# or
. my_script.sh

# Method 4: Run with full path
/path/to/my_script.sh
```

## Variables and Data Types

### Variable Declaration and Assignment

```bash
#!/bin/bash

# String variables
name="John Doe"
city='New York'
message="Hello, $name!"  # Variable expansion in double quotes
literal='Hello, $name!'  # No expansion in single quotes

# Numeric variables
age=30
height=5.9

# Boolean-like variables (strings)
is_admin="true"
debug_mode="false"

# Environment variables
export PATH="/usr/local/bin:$PATH"
export DATABASE_URL="postgresql://localhost:5432/mydb"

# Read-only variables
readonly PI=3.14159
declare -r MAX_USERS=100

# Array variables
fruits=("apple" "banana" "cherry")
numbers=(1 2 3 4 5)
```

### Variable Scope

```bash
#!/bin/bash

# Global variable
global_var="I'm global"

function demo_scope() {
    # Local variable
    local local_var="I'm local"
    
    # Access global variable
    echo "Global: $global_var"
    echo "Local: $local_var"
    
    # Modify global variable
    global_var="Modified global"
}

demo_scope
echo "After function: $global_var"
# echo "$local_var"  # This would cause an error
```

### Special Variables

```bash
#!/bin/bash

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "All arguments (as string): $*"
echo "Number of arguments: $#"
echo "Exit status of last command: $?"
echo "Process ID of script: $$"
echo "Process ID of last background command: $!"
echo "Current working directory: $PWD"
echo "Home directory: $HOME"
echo "Current user: $USER"
```

### Variable Expansion and Manipulation

```bash
#!/bin/bash

filename="document.pdf"

# Parameter expansion
echo "Filename: ${filename}"
echo "Extension: ${filename##*.}"
echo "Name without extension: ${filename%.*}"
echo "Directory: ${filename%/*}"

# Default values
echo "Value: ${undefined_var:-default_value}"
echo "Value: ${undefined_var:=assigned_default}"

# String length
echo "Length: ${#filename}"

# Substring extraction
text="Hello World"
echo "Substring: ${text:0:5}"  # "Hello"
echo "Substring: ${text:6}"    # "World"

# Case conversion (Bash 4+)
echo "Uppercase: ${text^^}"
echo "Lowercase: ${text,,}"
```

## User Input and Output

### Reading User Input

```bash
#!/bin/bash

# Basic input
echo "What is your name?"
read name
echo "Hello, $name!"

# Input with prompt
read -p "Enter your age: " age
echo "You are $age years old."

# Silent input (for passwords)
read -s -p "Enter password: " password
echo  # New line after password input

# Input with timeout
if read -t 5 -p "Enter something (5 seconds): " input; then
    echo "You entered: $input"
else
    echo "Timeout!"
fi

# Reading multiple values
read -p "Enter first and last name: " first last
echo "First: $first, Last: $last"

# Reading into an array
echo "Enter three colors:"
read -a colors
echo "Colors: ${colors[@]}"
```

### Advanced Input Handling

```bash
#!/bin/bash

# Input validation
while true; do
    read -p "Enter a number between 1 and 10: " num
    if [[ "$num" =~ ^[1-9]$|^10$ ]]; then
        echo "Valid number: $num"
        break
    else
        echo "Invalid input. Please try again."
    fi
done

# Select menu
echo "Choose your favorite programming language:"
select lang in "Python" "Bash" "JavaScript" "Go" "Quit"; do
    case $lang in
        "Python"|"Bash"|"JavaScript"|"Go")
            echo "Great choice! You selected $lang"
            break
            ;;
        "Quit")
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
```

### Output Formatting

```bash
#!/bin/bash

# Basic output
echo "Simple text"
printf "Formatted text: %s\n" "Hello World"

# Formatting with printf
name="Alice"
age=25
printf "Name: %-10s Age: %3d\n" "$name" "$age"

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}Error message${NC}"
echo -e "${GREEN}Success message${NC}"
echo -e "${YELLOW}Warning message${NC}"

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        ERROR)   echo -e "${timestamp} [${RED}ERROR${NC}] $message" >&2 ;;
        WARN)    echo -e "${timestamp} [${YELLOW}WARN${NC}] $message" ;;
        INFO)    echo -e "${timestamp} [${GREEN}INFO${NC}] $message" ;;
        DEBUG)   [[ "${DEBUG:-false}" == "true" ]] && echo -e "${timestamp} [DEBUG] $message" ;;
    esac
}

# Usage
log INFO "Application started"
log WARN "This is a warning"
log ERROR "Something went wrong"
```

## Command Line Arguments

### Processing Arguments

```bash
#!/bin/bash

# Simple argument processing
if [ $# -eq 0 ]; then
    echo "Usage: $0 <argument>"
    exit 1
fi

echo "Script: $0"
echo "Arguments: $@"
echo "Count: $#"

# Iterate through all arguments
for arg in "$@"; do
    echo "Processing: $arg"
done
```

### Advanced Argument Processing with getopts

```bash
#!/bin/bash

# Initialize variables
verbose=false
output_file=""
input_file=""

# Function to show usage
usage() {
    echo "Usage: $0 [-v] [-o output_file] [-i input_file] [-h]"
    echo "  -v: Verbose mode"
    echo "  -o: Output file"
    echo "  -i: Input file"
    echo "  -h: Show this help"
    exit 1
}

# Process options
while getopts "vo:i:h" opt; do
    case $opt in
        v)
            verbose=true
            echo "Verbose mode enabled"
            ;;
        o)
            output_file="$OPTARG"
            echo "Output file: $output_file"
            ;;
        i)
            input_file="$OPTARG"
            echo "Input file: $input_file"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Shift past the options
shift $((OPTIND-1))

# Remaining arguments
echo "Remaining arguments: $@"
```

### Long Options Processing

```bash
#!/bin/bash

# Process long and short options
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            verbose=true
            shift
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -i|--input)
            input_file="$2"
            shift 2
            ;;
        --config=*)
            config_file="${1#*=}"
            shift
            ;;
        -h|--help)
            usage
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            ;;
        *)
            # Positional argument
            positional_args+=("$1")
            shift
            ;;
    esac
done
```

## Conditional Statements

### Basic if Statements

```bash
#!/bin/bash

# Simple if statement
if [ -f "myfile.txt" ]; then
    echo "File exists"
fi

# if-else
if [ -d "/etc" ]; then
    echo "Directory /etc exists"
else
    echo "Directory /etc does not exist"
fi

# if-elif-else
read -p "Enter a number: " num
if [ "$num" -gt 0 ]; then
    echo "Positive number"
elif [ "$num" -lt 0 ]; then
    echo "Negative number"
else
    echo "Zero"
fi
```

### Test Operators

```bash
#!/bin/bash

# Numeric comparisons
if [ "$a" -eq "$b" ]; then echo "a equals b"; fi
if [ "$a" -ne "$b" ]; then echo "a not equals b"; fi
if [ "$a" -gt "$b" ]; then echo "a greater than b"; fi
if [ "$a" -ge "$b" ]; then echo "a greater than or equal b"; fi
if [ "$a" -lt "$b" ]; then echo "a less than b"; fi
if [ "$a" -le "$b" ]; then echo "a less than or equal b"; fi

# String comparisons
if [ "$str1" = "$str2" ]; then echo "strings equal"; fi
if [ "$str1" != "$str2" ]; then echo "strings not equal"; fi
if [ -z "$str" ]; then echo "string is empty"; fi
if [ -n "$str" ]; then echo "string is not empty"; fi

# File tests
if [ -f "$file" ]; then echo "file exists"; fi
if [ -d "$dir" ]; then echo "directory exists"; fi
if [ -r "$file" ]; then echo "file is readable"; fi
if [ -w "$file" ]; then echo "file is writable"; fi
if [ -x "$file" ]; then echo "file is executable"; fi
if [ -s "$file" ]; then echo "file is not empty"; fi
```

### Advanced Conditional Constructs

```bash
#!/bin/bash

# Double brackets for advanced conditions
if [[ "$string" =~ ^[0-9]+$ ]]; then
    echo "String contains only numbers"
fi

if [[ "$filename" == *.txt ]]; then
    echo "Text file"
fi

# Logical operators
if [[ -f "$file" && -r "$file" ]]; then
    echo "File exists and is readable"
fi

if [[ "$user" == "admin" || "$user" == "root" ]]; then
    echo "Administrative user"
fi

# Case statement
read -p "Enter a letter: " letter
case "$letter" in
    [aeiou])
        echo "Vowel"
        ;;
    [bcdfghjklmnpqrstvwxyz])
        echo "Consonant"
        ;;
    [0-9])
        echo "Number"
        ;;
    *)
        echo "Other character"
        ;;
esac
```

## Loops

### For Loops

```bash
#!/bin/bash

# Basic for loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# For loop with range
for i in {1..10}; do
    echo "Count: $i"
done

# For loop with step
for i in {0..100..10}; do
    echo "Step: $i"
done

# C-style for loop
for ((i=1; i<=10; i++)); do
    echo "C-style: $i"
done

# Loop through files
for file in *.txt; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
    fi
done

# Loop through command output
for user in $(cat /etc/passwd | cut -d: -f1); do
    echo "User: $user"
done

# Loop through array
fruits=("apple" "banana" "cherry")
for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done
```

### While and Until Loops

```bash
#!/bin/bash

# While loop
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Reading file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < input.txt

# Infinite loop with break
while true; do
    read -p "Enter 'quit' to exit: " input
    if [ "$input" = "quit" ]; then
        break
    fi
    echo "You entered: $input"
done

# Until loop
counter=1
until [ $counter -gt 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done

# Loop with continue
for i in {1..10}; do
    if [ $((i % 2)) -eq 0 ]; then
        continue  # Skip even numbers
    fi
    echo "Odd number: $i"
done
```

## Functions

### Function Basics

```bash
#!/bin/bash

# Simple function
greet() {
    echo "Hello, World!"
}

# Function with parameters
greet_person() {
    local name=$1
    local age=$2
    echo "Hello, $name! You are $age years old."
}

# Function with return value
add_numbers() {
    local num1=$1
    local num2=$2
    local result=$((num1 + num2))
    echo $result  # Return value via echo
}

# Function with actual return code
is_number() {
    local input=$1
    if [[ "$input" =~ ^[0-9]+$ ]]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Usage
greet
greet_person "Alice" 25

sum=$(add_numbers 10 20)
echo "Sum: $sum"

if is_number "123"; then
    echo "Valid number"
else
    echo "Invalid number"
fi
```

### Advanced Function Features

```bash
#!/bin/bash

# Function with default parameters
create_user() {
    local username=${1:-"defaultuser"}
    local home_dir=${2:-"/home/$username"}
    local shell=${3:-"/bin/bash"}
    
    echo "Creating user: $username"
    echo "Home directory: $home_dir"
    echo "Shell: $shell"
}

# Function with variable arguments
print_all() {
    echo "Function name: ${FUNCNAME[0]}"
    echo "Number of arguments: $#"
    
    local i=1
    for arg in "$@"; do
        echo "Arg $i: $arg"
        ((i++))
    done
}

# Recursive function
factorial() {
    local n=$1
    if [ $n -le 1 ]; then
        echo 1
    else
        local prev=$(factorial $((n-1)))
        echo $((n * prev))
    fi
}

# Function with local arrays
process_files() {
    local files=("$@")
    local count=0
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "Processing: $file"
            ((count++))
        fi
    done
    
    echo "Processed $count files"
}

# Usage examples
create_user "john"
create_user "jane" "/custom/home" "/bin/zsh"

print_all "arg1" "arg2" "arg3"

result=$(factorial 5)
echo "5! = $result"

process_files *.txt *.md
```

## Arrays

### Array Basics

```bash
#!/bin/bash

# Array declaration
fruits=("apple" "banana" "cherry")
numbers=(1 2 3 4 5)
mixed=("text" 123 "more text")

# Empty array
empty_array=()

# Associative arrays (Bash 4+)
declare -A colors
colors["red"]="#FF0000"
colors["green"]="#00FF00"
colors["blue"]="#0000FF"

# Array operations
echo "First fruit: ${fruits[0]}"
echo "All fruits: ${fruits[@]}"
echo "All fruits (quoted): ${fruits[*]}"
echo "Array length: ${#fruits[@]}"
echo "Length of first element: ${#fruits[0]}"

# Adding elements
fruits+=("date")
fruits[10]="elderberry"  # Sparse array

# Removing elements
unset fruits[1]  # Remove banana
echo "After removal: ${fruits[@]}"
```

### Advanced Array Operations

```bash
#!/bin/bash

# Array slicing
numbers=(0 1 2 3 4 5 6 7 8 9)
echo "Elements 2-5: ${numbers[@]:2:4}"
echo "From index 3: ${numbers[@]:3}"

# Array searching and replacement
text_array=("hello world" "goodbye world" "hello universe")
echo "Replace 'world' with 'earth': ${text_array[@]/world/earth}"
echo "Replace all 'o' with '0': ${text_array[@]//o/0}"

# Looping through arrays
for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# Looping with indices
for i in "${!fruits[@]}"; do
    echo "Index $i: ${fruits[i]}"
done

# Associative array operations
for key in "${!colors[@]}"; do
    echo "Color $key: ${colors[$key]}"
done

# Array as function parameters
print_array() {
    local arr=("$@")
    for element in "${arr[@]}"; do
        echo "Element: $element"
    done
}

print_array "${fruits[@]}"
```

## String Manipulation

### String Operations

```bash
#!/bin/bash

text="Hello, World! This is a test string."

# String length
echo "Length: ${#text}"

# Substring extraction
echo "Substring (7-12): ${text:7:5}"  # "World"
echo "From position 7: ${text:7}"

# Pattern matching and removal
filename="document.backup.tar.gz"
echo "Remove shortest match from end: ${filename%.*}"     # document.backup.tar
echo "Remove longest match from end: ${filename%%.*}"    # document
echo "Remove shortest match from start: ${filename#*.}"  # backup.tar.gz
echo "Remove longest match from start: ${filename##*.}"  # gz

# String replacement
echo "Replace first 'o': ${text/o/O}"
echo "Replace all 'o': ${text//o/O}"
echo "Replace at beginning: ${text/#Hello/Hi}"
echo "Replace at end: ${text/%string./text!}"

# Case conversion (Bash 4+)
echo "Uppercase: ${text^^}"
echo "Lowercase: ${text,,}"
echo "Capitalize first: ${text^}"
echo "Capitalize words: ${text^^[tw]}"
```

### String Validation and Processing

```bash
#!/bin/bash

# Email validation function
validate_email() {
    local email=$1
    local pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    
    if [[ $email =~ $pattern ]]; then
        return 0
    else
        return 1
    fi
}

# URL validation
validate_url() {
    local url=$1
    local pattern="^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$"
    
    [[ $url =~ $pattern ]]
}

# String trimming
trim() {
    local var="$1"
    # Remove leading whitespace
    var="${var#"${var%%[![:space:]]*}"}"
    # Remove trailing whitespace
    var="${var%"${var##*[![:space:]]}"}"
    echo "$var"
}

# Usage examples
if validate_email "user@example.com"; then
    echo "Valid email"
else
    echo "Invalid email"
fi

trimmed=$(trim "  hello world  ")
echo "Trimmed: '$trimmed'"
```

This guide provides a basic overview of shell scripting. With these fundamentals, you can start writing your own scripts to automate tasks and improve your productivity in the Linux environment.

## File Operations

### File and Directory Tests

```bash
#!/bin/bash

file_operations() {
    local target=$1
    
    echo "Checking: $target"
    
    # File existence and type checks
    if [ -e "$target" ]; then
        echo "✓ Exists"
        
        if [ -f "$target" ]; then
            echo "✓ Regular file"
        elif [ -d "$target" ]; then
            echo "✓ Directory"
        elif [ -L "$target" ]; then
            echo "✓ Symbolic link"
        elif [ -c "$target" ]; then
            echo "✓ Character device"
        elif [ -b "$target" ]; then
            echo "✓ Block device"
        elif [ -p "$target" ]; then
            echo "✓ Named pipe"
        elif [ -S "$target" ]; then
            echo "✓ Socket"
        fi
        
        # Permission checks
        [ -r "$target" ] && echo "✓ Readable"
        [ -w "$target" ] && echo "✓ Writable"
        [ -x "$target" ] && echo "✓ Executable"
        
        # Size check
        [ -s "$target" ] && echo "✓ Not empty"
        
        # Ownership checks
        [ -O "$target" ] && echo "✓ Owned by current user"
        [ -G "$target" ] && echo "✓ Owned by current group"
    else
        echo "✗ Does not exist"
    fi
}
```

### File Manipulation

```bash
#!/bin/bash

# Safe file operations with error checking
safe_copy() {
    local source=$1
    local destination=$2
    
    if [ ! -f "$source" ]; then
        echo "Error: Source file '$source' does not exist" >&2
        return 1
    fi
    
    if [ -f "$destination" ]; then
        read -p "Destination '$destination' exists. Overwrite? (y/n): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo "Copy cancelled"
            return 1
        fi
    fi
    
    if cp "$source" "$destination"; then
        echo "Successfully copied '$source' to '$destination'"
        return 0
    else
        echo "Error: Failed to copy file" >&2
        return 1
    fi
}

# File backup with timestamp
backup_file() {
    local file=$1
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup="${file}.backup_${timestamp}"
    
    if [ -f "$file" ]; then
        cp "$file" "$backup"
        echo "Backup created: $backup"
    else
        echo "Error: File '$file' not found" >&2
        return 1
    fi
}

# Directory traversal
traverse_directory() {
    local dir=${1:-.}
    local depth=${2:-0}
    local max_depth=${3:-3}
    
    if [ $depth -gt $max_depth ]; then
        return
    fi
    
    local indent=$(printf "%*s" $((depth * 2)) "")
    
    for item in "$dir"/*; do
        if [ -e "$item" ]; then
            local basename=$(basename "$item")
            if [ -d "$item" ]; then
                echo "${indent}📁 $basename/"
                traverse_directory "$item" $((depth + 1)) $max_depth
            else
                echo "${indent}📄 $basename"
            fi
        fi
    done
}
```

## Process Management

### Background Jobs and Process Control

```bash
#!/bin/bash

# Start background job
start_background_job() {
    local command=$1
    echo "Starting background job: $command"
    
    $command &
    local pid=$!
    
    echo "Job started with PID: $pid"
    echo $pid > "/tmp/job_${pid}.pid"
    
    return $pid
}

# Monitor process
monitor_process() {
    local pid=$1
    
    if kill -0 $pid 2>/dev/null; then
        echo "Process $pid is running"
        
        # Get process info
        if command -v ps >/dev/null; then
            ps -p $pid -o pid,ppid,user,time,command
        fi
        
        return 0
    else
        echo "Process $pid is not running"
        return 1
    fi
}

# Wait for process with timeout
wait_for_process() {
    local pid=$1
    local timeout=${2:-30}
    local interval=1
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        if ! kill -0 $pid 2>/dev/null; then
            echo "Process $pid finished"
            return 0
        fi
        
        sleep $interval
        elapsed=$((elapsed + interval))
        echo "Waiting... ${elapsed}s"
    done
    
    echo "Timeout waiting for process $pid"
    return 1
}

# Kill process gracefully
kill_process_gracefully() {
    local pid=$1
    local timeout=${2:-10}
    
    if ! kill -0 $pid 2>/dev/null; then
        echo "Process $pid is not running"
        return 0
    fi
    
    echo "Sending TERM signal to process $pid"
    kill -TERM $pid
    
    # Wait for graceful shutdown
    local count=0
    while [ $count -lt $timeout ]; do
        if ! kill -0 $pid 2>/dev/null; then
            echo "Process terminated gracefully"
            return 0
        fi
        sleep 1
        count=$((count + 1))
    done
    
    echo "Force killing process $pid"
    kill -KILL $pid
}
```

## Error Handling

### Comprehensive Error Handling

```bash
#!/bin/bash

# Set strict error handling
set -euo pipefail

# Error handling function
handle_error() {
    local exit_code=$?
    local line_number=$1
    
    echo "Error occurred in script at line $line_number: exit code $exit_code" >&2
    echo "Call stack:" >&2
    
    local frame=0
    while caller $frame; do
        ((frame++))
    done >&2
    
    cleanup
    exit $exit_code
}

# Set error trap
trap 'handle_error $LINENO' ERR

# Cleanup function
cleanup() {
    echo "Performing cleanup..."
    
    # Remove temporary files
    if [ -n "${TEMP_DIR:-}" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        echo "Removed temporary directory: $TEMP_DIR"
    fi
    
    # Kill background processes
    if [ -n "${BACKGROUND_PIDS:-}" ]; then
        for pid in $BACKGROUND_PIDS; do
            if kill -0 $pid 2>/dev/null; then
                kill $pid
                echo "Killed background process: $pid"
            fi
        done
    fi
}

# Set cleanup trap
trap cleanup EXIT

# Validation functions
validate_file() {
    local file=$1
    local description=${2:-"file"}
    
    if [ ! -f "$file" ]; then
        echo "Error: Required $description '$file' not found" >&2
        return 1
    fi
    
    if [ ! -r "$file" ]; then
        echo "Error: $description '$file' is not readable" >&2
        return 1
    fi
    
    return 0
}

validate_directory() {
    local dir=$1
    local description=${2:-"directory"}
    
    if [ ! -d "$dir" ]; then
        echo "Error: Required $description '$dir' not found" >&2
        return 1
    fi
    
    if [ ! -w "$dir" ]; then
        echo "Error: $description '$dir' is not writable" >&2
        return 1
    fi
    
    return 0
}

# Safe command execution
safe_execute() {
    local command="$1"
    local description="${2:-command}"
    
    echo "Executing: $description"
    
    if eval "$command"; then
        echo "✓ $description completed successfully"
        return 0
    else
        local exit_code=$?
        echo "✗ $description failed with exit code $exit_code" >&2
        return $exit_code
    fi
}
```

## Advanced Techniques

### Signal Handling

```bash
#!/bin/bash

# Signal handling example
setup_signal_handlers() {
    trap 'handle_sigint' INT
    trap 'handle_sigterm' TERM
    trap 'handle_sigusr1' USR1
    trap 'handle_sigusr2' USR2
}

handle_sigint() {
    echo "Received SIGINT (Ctrl+C)"
    echo "Gracefully shutting down..."
    cleanup
    exit 130
}

handle_sigterm() {
    echo "Received SIGTERM"
    echo "Terminating..."
    cleanup
    exit 143
}

handle_sigusr1() {
    echo "Received SIGUSR1 - toggling debug mode"
    if [ "${DEBUG_MODE:-false}" = "true" ]; then
        DEBUG_MODE=false
        echo "Debug mode disabled"
    else
        DEBUG_MODE=true
        echo "Debug mode enabled"
    fi
}

handle_sigusr2() {
    echo "Received SIGUSR2 - printing status"
    print_status
}

print_status() {
    echo "=== Status Report ==="
    echo "PID: $$"
    echo "User: $USER"
    echo "Working Directory: $PWD"
    echo "Uptime: $(uptime)"
    echo "===================="
}

setup_signal_handlers
```

### Inter-Process Communication

```bash
#!/bin/bash

# Named pipes (FIFO) example
create_named_pipe() {
    local pipe_name=$1
    
    if [ ! -p "$pipe_name" ]; then
        mkfifo "$pipe_name"
        echo "Created named pipe: $pipe_name"
    fi
}

# Producer process
producer() {
    local pipe=$1
    local count=${2:-10}
    
    for ((i=1; i<=count; i++)); do
        echo "Message $i: $(date)" > "$pipe"
        sleep 1
    done
    
    echo "END" > "$pipe"
}

# Consumer process
consumer() {
    local pipe=$1
    
    while IFS= read -r message; do
        if [ "$message" = "END" ]; then
            echo "Consumer: Received termination signal"
            break
        fi
        echo "Consumer: Received: $message"
    done < "$pipe"
}

# Shared memory using temporary files
create_shared_data() {
    local shared_file="/tmp/shared_data_$$"
    echo "0" > "$shared_file"
    echo "$shared_file"
}

increment_shared_counter() {
    local shared_file=$1
    local lockfile="${shared_file}.lock"
    
    # Simple file locking
    (
        flock -x 200
        local current=$(cat "$shared_file")
        echo $((current + 1)) > "$shared_file"
    ) 200>"$lockfile"
}
```

## Debugging

### Debug Techniques

```bash
#!/bin/bash

# Debug configuration
DEBUG=${DEBUG:-false}
VERBOSE=${VERBOSE:-false}

# Debug functions
debug() {
    if [ "$DEBUG" = "true" ]; then
        echo "[DEBUG $(date '+%H:%M:%S')] $*" >&2
    fi
}

verbose() {
    if [ "$VERBOSE" = "true" ] || [ "$DEBUG" = "true" ]; then
        echo "[VERBOSE] $*" >&2
    fi
}

# Function tracing
trace_function() {
    local func_name=$1
    shift
    
    debug "Entering function: $func_name with args: $*"
    local start_time=$(date +%s.%N)
    
    "$func_name" "$@"
    local exit_code=$?
    
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "N/A")
    
    debug "Exiting function: $func_name (exit code: $exit_code, duration: ${duration}s)"
    
    return $exit_code
}

# Variable inspection
inspect_vars() {
    echo "=== Variable Inspection ==="
    echo "Script: $0"
    echo "Arguments: $*"
    echo "Argument count: $#"
    echo "Process ID: $$"
    echo "Parent Process ID: $PPID"
    echo "User ID: $(id -u)"
    echo "Group ID: $(id -g)"
    echo "Working Directory: $PWD"
    echo "Shell: $SHELL"
    echo "=========================="
}

# Performance profiling
profile_command() {
    local command="$1"
    local description="${2:-command}"
    
    echo "Profiling: $description"
    
    local start_time=$(date +%s.%N)
    local start_memory=$(ps -o vsz= -p $$)
    
    eval "$command"
    local exit_code=$?
    
    local end_time=$(date +%s.%N)
    local end_memory=$(ps -o vsz= -p $$)
    
    local duration=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "N/A")
    local memory_diff=$((end_memory - start_memory))
    
    echo "Profile Results:"
    echo "  Duration: ${duration}s"
    echo "  Memory change: ${memory_diff}KB"
    echo "  Exit code: $exit_code"
    
    return $exit_code
}
```

## Best Practices

### Script Template with Best Practices

```bash
#!/usr/bin/env bash

# Script: comprehensive_template.sh
# Description: Template demonstrating shell scripting best practices
# Author: Your Name
# Version: 1.0
# Date: $(date +%Y-%m-%d)

# Strict error handling
set -euo pipefail

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_VERSION="1.0"

# Global variables
DEBUG=${DEBUG:-false}
VERBOSE=${VERBOSE:-false}
FORCE=${FORCE:-false}

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_debug() {
    if [ "$DEBUG" = "true" ]; then
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
    fi
}

# Help function
show_help() {
    cat << EOF
$SCRIPT_NAME v$SCRIPT_VERSION

Usage: $SCRIPT_NAME [OPTIONS] [ARGUMENTS]

Description:
    Template script demonstrating best practices

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -d, --debug     Enable debug mode
    -f, --force     Force execution
    --version       Show version information

Examples:
    $SCRIPT_NAME --verbose file1.txt
    $SCRIPT_NAME --debug --force

EOF
}

# Version information
show_version() {
    echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

# Cleanup function
cleanup() {
    log_debug "Performing cleanup..."
    
    # Remove temporary files
    if [ -n "${TEMP_DIR:-}" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        log_debug "Removed temporary directory: $TEMP_DIR"
    fi
}

# Error handler
error_handler() {
    local exit_code=$?
    local line_number=$1
    
    log_error "Script failed at line $line_number with exit code $exit_code"
    cleanup
    exit $exit_code
}

# Set traps
trap 'error_handler $LINENO' ERR
trap cleanup EXIT

# Argument parsing
parse_arguments() {
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
            -d|--debug)
                DEBUG=true
                VERBOSE=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            --version)
                show_version
                exit 0
                ;;
            --)
                shift
                break
                ;;
            -*)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                # Positional argument
                POSITIONAL_ARGS+=("$1")
                shift
                ;;
        esac
    done
    
    # Set positional parameters
    set -- "${POSITIONAL_ARGS[@]}" "$@"
}

# Main function
main() {
    local -a POSITIONAL_ARGS=()
    
    parse_arguments "$@"
    
    log_info "Starting $SCRIPT_NAME v$SCRIPT_VERSION"
    log_debug "Debug mode enabled"
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    log_debug "Created temporary directory: $TEMP_DIR"
    
    # Main script logic here
    log_info "Script completed successfully"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

## Real-World Examples

### System Backup Script

```bash
#!/usr/bin/env bash

# System backup script with rotation
backup_system() {
    local backup_source=${1:-"/home"}
    local backup_dest=${2:-"/backup"}
    local retention_days=${3:-7}
    
    log_info "Starting system backup"
    log_info "Source: $backup_source"
    log_info "Destination: $backup_dest"
    log_info "Retention: $retention_days days"
    
    # Check prerequisites
    command -v rsync >/dev/null || {
        log_error "rsync not found"
        return 1
    }
    
    [ -d "$backup_source" ] || {
        log_error "Source directory not found: $backup_source"
        return 1
    }
    
    [ -d "$backup_dest" ] || {
        log_info "Creating backup destination: $backup_dest"
        mkdir -p "$backup_dest"
    }
    
    # Create timestamped backup
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$backup_dest/backup_$timestamp"
    
    log_info "Creating backup in: $backup_dir"
    
    rsync -av --progress "$backup_source/" "$backup_dir/" || {
        log_error "Backup failed"
        return 1
    }
    
    # Create latest symlink
    local latest_link="$backup_dest/latest"
    ln -sfn "$backup_dir" "$latest_link"
    
    # Cleanup old backups
    find "$backup_dest" -name "backup_*" -type d -mtime +$retention_days -exec rm -rf {} \; 2>/dev/null || true
    
    log_info "Backup completed successfully"
    log_info "Backup location: $backup_dir"
    
    # Generate report
    local backup_size=$(du -sh "$backup_dir" | cut -f1)
    echo "Backup Report - $(date)"
    echo "Size: $backup_size"
    echo "Location: $backup_dir"
    echo "Files: $(find "$backup_dir" -type f | wc -l)"
}
```

### Log Analysis Script

```bash
#!/usr/bin/env bash

# Advanced log analysis
analyze_logs() {
    local log_file=${1:-"/var/log/syslog"}
    local days=${2:-1}
    local output_dir=${3:-"./log_analysis"}
    
    log_info "Analyzing log file: $log_file"
    
    # Create output directory
    mkdir -p "$output_dir"
    
    local today=$(date +%Y-%m-%d)
    local report_file="$output_dir/log_analysis_$today.txt"
    
    {
        echo "Log Analysis Report - $(date)"
        echo "=================================="
        echo "Log file: $log_file"
        echo "Period: Last $days days"
        echo
        
        # Basic statistics
        echo "Statistics:"
        echo "----------"
        local total_lines=$(wc -l < "$log_file")
        echo "Total lines: $total_lines"
        
        # Recent entries
        local recent_date=$(date -d "$days days ago" +%Y-%m-%d)
        local recent_lines=$(grep "$recent_date" "$log_file" | wc -l)
        echo "Recent lines (last $days days): $recent_lines"
        
        # Error analysis
        echo
        echo "Error Analysis:"
        echo "---------------"
        grep -i "error" "$log_file" | tail -10
        
        # Top IP addresses (if applicable)
        echo
        echo "Top IP Addresses:"
        echo "----------------"
        grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$log_file" | \
        sort | uniq -c | sort -rn | head -10
        
        # Hourly distribution
        echo
        echo "Hourly Distribution:"
        echo "-------------------"
        awk '{print $3}' "$log_file" | cut -d: -f1 | sort | uniq -c | sort -rn
        
    } > "$report_file"
    
    log_info "Analysis complete. Report saved to: $report_file"
}
```

This comprehensive guide covers advanced shell scripting concepts and provides practical examples for real-world scenarios. Practice these concepts to become proficient in shell scripting.
