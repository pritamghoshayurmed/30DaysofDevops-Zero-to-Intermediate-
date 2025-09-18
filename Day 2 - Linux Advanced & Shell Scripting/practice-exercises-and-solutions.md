# Comprehensive Practice Exercises and Solutions

## Table of Contents
1. [Beginner Level Exercises](#beginner-level-exercises)
2. [Intermediate Level Exercises](#intermediate-level-exercises)
3. [Advanced Level Exercises](#advanced-level-exercises)
4. [Real-World Scenarios](#real-world-scenarios)
5. [Challenge Projects](#challenge-projects)

This comprehensive set of exercises is designed to test and reinforce your understanding of shell scripting, file permissions, and text processing. Exercises are organized by difficulty level with detailed solutions and explanations.

---

## Beginner Level Exercises

### Shell Scripting Basics

#### Exercise 1: Personal Information Script
**Difficulty:** ⭐ (Beginner)

Create a script that asks for user information and creates a formatted output.

**Requirements:**
- Prompt for: name, age, city, favorite color
- Display information in a nicely formatted way
- Validate that age is a number
- Handle empty inputs gracefully

**Solution:**
```bash
#!/bin/bash

# personal_info.sh - Collect and display personal information

echo "Personal Information Collector"
echo "============================="

# Function to read non-empty input
read_non_empty() {
    local prompt=$1
    local variable_name=$2
    local input
    
    while true; do
        read -p "$prompt: " input
        if [ -n "$input" ]; then
            eval "$variable_name='$input'"
            break
        else
            echo "This field cannot be empty. Please try again."
        fi
    done
}

# Function to read and validate age
read_age() {
    local age
    while true; do
        read -p "Enter your age: " age
        if [[ "$age" =~ ^[0-9]+$ ]] && [ "$age" -gt 0 ] && [ "$age" -lt 150 ]; then
            break
        else
            echo "Please enter a valid age (1-149)."
        fi
    done
    echo "$age"
}

# Collect information
read_non_empty "Enter your full name" name
age=$(read_age)
read_non_empty "Enter your city" city
read_non_empty "Enter your favorite color" color

# Display formatted information
echo
echo "==============================="
echo "       PERSONAL PROFILE        "
echo "==============================="
echo "Name:           $name"
echo "Age:            $age years old"
echo "Location:       $city"
echo "Favorite Color: $color"
echo "==============================="
echo "Profile created on: $(date)"
```

**Explanation:**
- Uses functions for code reusability
- Implements input validation
- Uses regex to validate numeric input
- Demonstrates proper error handling

#### Exercise 2: File Organizer
**Difficulty:** ⭐ (Beginner)

Write a script that organizes files in a directory by their extensions.

**Requirements:**
- Create subdirectories for different file types (images, documents, archives, etc.)
- Move files to appropriate directories
- Handle files without extensions
- Provide summary of operations

**Solution:**
```bash
#!/bin/bash

# file_organizer.sh - Organize files by extension

organize_directory() {
    local target_dir=${1:-.}
    local moved_count=0
    local skipped_count=0
    
    echo "Organizing files in: $target_dir"
    echo "==============================="
    
    # Create category directories
    declare -A categories=(
        ["images"]="jpg jpeg png gif bmp svg webp"
        ["documents"]="pdf doc docx txt md rtf odt"
        ["archives"]="zip tar gz bz2 rar 7z"
        ["audio"]="mp3 wav flac aac ogg"
        ["video"]="mp4 avi mkv mov wmv flv"
        ["code"]="py js html css php java cpp c h"
        ["data"]="csv json xml yaml yml"
    )
    
    # Create directories if they don't exist
    for category in "${!categories[@]}"; do
        mkdir -p "$target_dir/$category"
    done
    mkdir -p "$target_dir/misc"  # For uncategorized files
    
    # Process each file
    for file in "$target_dir"/*; do
        # Skip if it's a directory or doesn't exist
        if [ ! -f "$file" ]; then
            continue
        fi
        
        filename=$(basename "$file")
        extension="${filename##*.}"
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
        
        # Skip if no extension
        if [ "$filename" = "$extension" ]; then
            echo "Skipped: $filename (no extension)"
            ((skipped_count++))
            continue
        fi
        
        # Find appropriate category
        category_found=""
        for category in "${!categories[@]}"; do
            if [[ " ${categories[$category]} " == *" $extension "* ]]; then
                category_found=$category
                break
            fi
        done
        
        # Use misc category if no match found
        if [ -z "$category_found" ]; then
            category_found="misc"
        fi
        
        # Move file
        if mv "$file" "$target_dir/$category_found/"; then
            echo "Moved: $filename -> $category_found/"
            ((moved_count++))
        else
            echo "Failed to move: $filename"
            ((skipped_count++))
        fi
    done
    
    echo
    echo "Organization complete!"
    echo "Files moved: $moved_count"
    echo "Files skipped: $skipped_count"
    
    # Show summary
    echo
    echo "Directory structure:"
    for category in "${!categories[@]}" misc; do
        count=$(find "$target_dir/$category" -type f | wc -l)
        if [ "$count" -gt 0 ]; then
            echo "$category: $count files"
        fi
    done
}

# Main execution
if [ "$#" -eq 0 ]; then
    organize_directory
else
    organize_directory "$1"
fi
```

**Explanation:**
- Uses associative arrays to categorize file extensions
- Demonstrates string manipulation for extension extraction
- Includes error handling and progress reporting
- Shows how to work with directories and file operations

### File Permissions Exercises

#### Exercise 3: Permission Analyzer
**Difficulty:** ⭐ (Beginner)

Create a script that analyzes file permissions and provides human-readable output.

**Requirements:**
- Accept file/directory path as argument
- Display detailed permission information
- Show octal and symbolic representations
- Identify potential security issues

**Solution:**
```bash
#!/bin/bash

# permission_analyzer.sh - Analyze file permissions

analyze_permissions() {
    local target=$1
    
    if [ ! -e "$target" ]; then
        echo "Error: '$target' does not exist" >&2
        return 1
    fi
    
    echo "Permission Analysis for: $target"
    echo "================================="
    
    # Get file statistics
    local stat_output=$(stat -c "%a %U %G %F %s" "$target")
    read -r octal_perms owner group file_type size <<< "$stat_output"
    
    local symbolic_perms=$(ls -ld "$target" | cut -d' ' -f1)
    
    echo "File Type: $file_type"
    echo "Owner: $owner"
    echo "Group: $group"
    echo "Size: $size bytes"
    echo
    
    # Display permissions
    echo "Permissions:"
    echo "-----------"
    echo "Octal: $octal_perms"
    echo "Symbolic: $symbolic_perms"
    echo
    
    # Break down permissions
    local user_perms=${octal_perms:0:1}
    local group_perms=${octal_perms:1:1}
    local other_perms=${octal_perms:2:1}
    
    echo "Detailed Breakdown:"
    decode_octal_permissions "Owner" "$user_perms"
    decode_octal_permissions "Group" "$group_perms"
    decode_octal_permissions "Others" "$other_perms"
    echo
    
    # Security analysis
    echo "Security Analysis:"
    echo "-----------------"
    
    # Check for world-writable
    if [ $((other_perms & 2)) -ne 0 ]; then
        echo "⚠️  WARNING: File is world-writable"
    fi
    
    # Check for world-readable sensitive files
    if [[ "$target" == *"passwd"* ]] || [[ "$target" == *"shadow"* ]]; then
        if [ $((other_perms & 4)) -ne 0 ]; then
            echo "⚠️  WARNING: Sensitive file is world-readable"
        fi
    fi
    
    # Check for executable files
    if [ $((user_perms & 1)) -ne 0 ]; then
        echo "ℹ️  File is executable by owner"
    fi
    
    # Check for SUID/SGID
    if [[ "$symbolic_perms" == *"s"* ]]; then
        echo "⚠️  WARNING: File has SUID or SGID bit set"
    fi
    
    # Check for sticky bit
    if [[ "$symbolic_perms" == *"t"* ]]; then
        echo "ℹ️  File has sticky bit set"
    fi
}

decode_octal_permissions() {
    local category=$1
    local octal=$2
    local permissions=""
    
    # Read permission
    if [ $((octal & 4)) -ne 0 ]; then
        permissions="${permissions}read, "
    fi
    
    # Write permission
    if [ $((octal & 2)) -ne 0 ]; then
        permissions="${permissions}write, "
    fi
    
    # Execute permission
    if [ $((octal & 1)) -ne 0 ]; then
        permissions="${permissions}execute, "
    fi
    
    # Remove trailing comma and space
    permissions=${permissions%, }
    
    if [ -z "$permissions" ]; then
        permissions="no permissions"
    fi
    
    printf "%-8s: %s\n" "$category" "$permissions"
}

# Main execution
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <file_or_directory>"
    exit 1
fi

analyze_permissions "$1"
```

**Explanation:**
- Uses `stat` command to get detailed file information
- Demonstrates bitwise operations for permission checking
- Shows security analysis techniques
- Provides comprehensive permission breakdown

### Text Processing Exercises

#### Exercise 4: Log File Analyzer
**Difficulty:** ⭐ (Beginner)

Create a script that analyzes web server log files and provides basic statistics.

**Requirements:**
- Count total requests
- Find most frequent IP addresses
- Count different HTTP status codes
- Show top requested pages

**Solution:**
```bash
#!/bin/bash

# log_analyzer.sh - Basic web log analysis

analyze_log() {
    local log_file=$1
    
    if [ ! -f "$log_file" ]; then
        echo "Error: Log file '$log_file' not found" >&2
        return 1
    fi
    
    echo "Web Log Analysis Report"
    echo "======================"
    echo "Log file: $log_file"
    echo "Analysis date: $(date)"
    echo
    
    # Basic statistics
    echo "Basic Statistics:"
    echo "----------------"
    local total_lines=$(wc -l < "$log_file")
    echo "Total log entries: $total_lines"
    
    local unique_ips=$(awk '{print $1}' "$log_file" | sort | uniq | wc -l)
    echo "Unique IP addresses: $unique_ips"
    
    local date_range_start=$(head -1 "$log_file" | awk '{print $4}' | tr -d '[')
    local date_range_end=$(tail -1 "$log_file" | awk '{print $4}' | tr -d '[')
    echo "Date range: $date_range_start to $date_range_end"
    echo
    
    # Top IP addresses
    echo "Top 10 IP Addresses:"
    echo "-------------------"
    awk '{print $1}' "$log_file" | sort | uniq -c | sort -rn | head -10 | \
    while read count ip; do
        printf "%-15s: %d requests\n" "$ip" "$count"
    done
    echo
    
    # HTTP status codes
    echo "HTTP Status Codes:"
    echo "-----------------"
    awk '{print $9}' "$log_file" | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -rn | \
    while read count status; do
        case $status in
            2*) status_desc="Success" ;;
            3*) status_desc="Redirection" ;;
            4*) status_desc="Client Error" ;;
            5*) status_desc="Server Error" ;;
            *) status_desc="Unknown" ;;
        esac
        printf "%s (%s): %d requests\n" "$status" "$status_desc" "$count"
    done
    echo
    
    # Top requested pages
    echo "Top 10 Requested Pages:"
    echo "----------------------"
    awk '{print $7}' "$log_file" | sort | uniq -c | sort -rn | head -10 | \
    while read count page; do
        printf "%-8d %s\n" "$count" "$page"
    done
    echo
    
    # Request methods
    echo "HTTP Methods:"
    echo "------------"
    awk '{print $6}' "$log_file" | tr -d '"' | sort | uniq -c | sort -rn | \
    while read count method; do
        printf "%-8s: %d requests\n" "$method" "$count"
    done
    echo
    
    # Hourly distribution
    echo "Hourly Request Distribution:"
    echo "---------------------------"
    awk '{print substr($4, 14, 2)}' "$log_file" | sort | uniq -c | sort -k2n | \
    while read count hour; do
        printf "%s:00 - %d requests\n" "$hour" "$count"
    done
}

# Generate sample log file for testing
generate_sample_log() {
    local sample_file="sample_access.log"
    
    echo "Generating sample log file: $sample_file"
    
    # Sample log entries in Common Log Format
    cat > "$sample_file" << 'EOF'
192.168.1.10 - - [10/Oct/2023:13:55:36 +0000] "GET / HTTP/1.1" 200 2326
192.168.1.15 - - [10/Oct/2023:13:56:10 +0000] "GET /about.html HTTP/1.1" 200 1543
192.168.1.10 - - [10/Oct/2023:13:56:25 +0000] "POST /login HTTP/1.1" 200 891
203.0.113.50 - - [10/Oct/2023:14:02:15 +0000] "GET /products HTTP/1.1" 404 456
192.168.1.15 - - [10/Oct/2023:14:05:45 +0000] "GET /contact.html HTTP/1.1" 200 1234
203.0.113.50 - - [10/Oct/2023:14:12:33 +0000] "GET /nonexistent HTTP/1.1" 404 456
192.168.1.10 - - [10/Oct/2023:14:15:22 +0000] "GET / HTTP/1.1" 200 2326
10.0.0.25 - - [10/Oct/2023:14:18:41 +0000] "GET /admin HTTP/1.1" 403 789
192.168.1.15 - - [10/Oct/2023:14:22:18 +0000] "GET /about.html HTTP/1.1" 200 1543
203.0.113.50 - - [10/Oct/2023:15:01:07 +0000] "GET / HTTP/1.1" 200 2326
EOF
    
    echo "Sample log file created with 10 entries"
}

# Main execution
case "${1:-}" in
    "sample")
        generate_sample_log
        ;;
    "")
        echo "Usage: $0 <log_file> | sample"
        echo "  log_file: Path to web server log file"
        echo "  sample:   Generate a sample log file for testing"
        exit 1
        ;;
    *)
        analyze_log "$1"
        ;;
esac
```

**Explanation:**
- Demonstrates awk field processing
- Uses sort and uniq for counting and analysis
- Shows pattern matching for status code categorization
- Includes sample data generation for testing

---

## Intermediate Level Exercises

### Shell Scripting - System Administration

#### Exercise 5: System Health Monitor
**Difficulty:** ⭐⭐ (Intermediate)

Create a comprehensive system monitoring script that checks various system health metrics.

**Requirements:**
- Monitor CPU usage, memory usage, disk space
- Check running processes and system load
- Alert when thresholds are exceeded
- Generate HTML report
- Log results with timestamps

**Solution:**
```bash
#!/bin/bash

# system_health_monitor.sh - Comprehensive system health monitoring

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="$SCRIPT_DIR/system_health.log"
readonly HTML_REPORT="$SCRIPT_DIR/system_health_report.html"

# Thresholds
readonly CPU_THRESHOLD=80
readonly MEMORY_THRESHOLD=85
readonly DISK_THRESHOLD=90
readonly LOAD_THRESHOLD=2.0

# Colors for output
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m'

# Logging function
log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    echo -e "[$level] $message"
}

# Check CPU usage
check_cpu_usage() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    cpu_usage=${cpu_usage%.*}  # Remove decimal part
    
    if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
        log_message "WARN" "High CPU usage: ${cpu_usage}%"
        echo -e "${YELLOW}CPU Usage: ${cpu_usage}% (HIGH)${NC}"
        return 1
    else
        log_message "INFO" "CPU usage normal: ${cpu_usage}%"
        echo -e "${GREEN}CPU Usage: ${cpu_usage}% (OK)${NC}"
        return 0
    fi
}

# Check memory usage
check_memory_usage() {
    local memory_info=$(free | grep Mem)
    local total_memory=$(echo "$memory_info" | awk '{print $2}')
    local used_memory=$(echo "$memory_info" | awk '{print $3}')
    local memory_percentage=$((used_memory * 100 / total_memory))
    
    if [ "$memory_percentage" -gt "$MEMORY_THRESHOLD" ]; then
        log_message "WARN" "High memory usage: ${memory_percentage}%"
        echo -e "${YELLOW}Memory Usage: ${memory_percentage}% (HIGH)${NC}"
        return 1
    else
        log_message "INFO" "Memory usage normal: ${memory_percentage}%"
        echo -e "${GREEN}Memory Usage: ${memory_percentage}% (OK)${NC}"
        return 0
    fi
}

# Check disk usage
check_disk_usage() {
    local issues=0
    echo "Disk Usage:"
    
    while read -r filesystem size used available percentage mountpoint; do
        # Skip header and non-numeric percentages
        if [[ "$percentage" =~ ^[0-9]+% ]]; then
            local usage_num=${percentage%\%}
            
            if [ "$usage_num" -gt "$DISK_THRESHOLD" ]; then
                log_message "WARN" "High disk usage on $mountpoint: $percentage"
                echo -e "  ${YELLOW}$mountpoint: $percentage (HIGH)${NC}"
                ((issues++))
            else
                log_message "INFO" "Disk usage on $mountpoint: $percentage"
                echo -e "  ${GREEN}$mountpoint: $percentage (OK)${NC}"
            fi
        fi
    done < <(df -h)
    
    return $issues
}

# Check system load
check_system_load() {
    local load_avg=$(uptime | awk '{print $(NF-2)}' | cut -d',' -f1)
    local load_comparison=$(echo "$load_avg > $LOAD_THRESHOLD" | bc -l)
    
    if [ "$load_comparison" -eq 1 ]; then
        log_message "WARN" "High system load: $load_avg"
        echo -e "${YELLOW}System Load: $load_avg (HIGH)${NC}"
        return 1
    else
        log_message "INFO" "System load normal: $load_avg"
        echo -e "${GREEN}System Load: $load_avg (OK)${NC}"
        return 0
    fi
}

# Check top processes
check_top_processes() {
    echo "Top CPU-consuming processes:"
    ps aux --sort=-%cpu | head -6 | tail -5 | while read -r user pid cpu mem vsz rss tty stat start time command; do
        if (( $(echo "$cpu > 10" | bc -l) )); then
            echo -e "  ${YELLOW}$user $pid $cpu% $command${NC}"
        else
            echo "  $user $pid $cpu% $command"
        fi
    done
    
    echo "Top Memory-consuming processes:"
    ps aux --sort=-%mem | head -6 | tail -5 | while read -r user pid cpu mem vsz rss tty stat start time command; do
        if (( $(echo "$mem > 10" | bc -l) )); then
            echo -e "  ${YELLOW}$user $pid $mem% $command${NC}"
        else
            echo "  $user $pid $mem% $command"
        fi
    done
}

# Generate HTML report
generate_html_report() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local memory_info=$(free | grep Mem)
    local total_memory=$(echo "$memory_info" | awk '{print $2}')
    local used_memory=$(echo "$memory_info" | awk '{print $3}')
    local memory_percentage=$((used_memory * 100 / total_memory))
    local load_avg=$(uptime | awk '{print $(NF-2)}' | cut -d',' -f1)
    local uptime_info=$(uptime -p)
    
    cat > "$HTML_REPORT" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Health Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #f4f4f4; padding: 20px; border-radius: 5px; }
        .metric { margin: 10px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .ok { background-color: #d4edda; border-color: #c3e6cb; }
        .warning { background-color: #fff3cd; border-color: #ffeaa7; }
        .critical { background-color: #f8d7da; border-color: #f5c6cb; }
        .progress-bar { width: 100%; background-color: #e0e0e0; border-radius: 10px; }
        .progress { height: 20px; border-radius: 10px; text-align: center; line-height: 20px; }
        .green { background-color: #4CAF50; }
        .yellow { background-color: #FF9800; }
        .red { background-color: #F44336; }
    </style>
</head>
<body>
    <div class="header">
        <h1>System Health Report</h1>
        <p><strong>Generated:</strong> $(date)</p>
        <p><strong>Hostname:</strong> $(hostname)</p>
        <p><strong>Uptime:</strong> $uptime_info</p>
    </div>
    
    <div class="metric $([ "${cpu_usage%.*}" -gt "$CPU_THRESHOLD" ] && echo "warning" || echo "ok")">
        <h3>CPU Usage</h3>
        <div class="progress-bar">
            <div class="progress $([ "${cpu_usage%.*}" -gt "$CPU_THRESHOLD" ] && echo "yellow" || echo "green")" 
                 style="width: ${cpu_usage%.*}%;">${cpu_usage%.*}%</div>
        </div>
    </div>
    
    <div class="metric $([ "$memory_percentage" -gt "$MEMORY_THRESHOLD" ] && echo "warning" || echo "ok")">
        <h3>Memory Usage</h3>
        <div class="progress-bar">
            <div class="progress $([ "$memory_percentage" -gt "$MEMORY_THRESHOLD" ] && echo "yellow" || echo "green")" 
                 style="width: ${memory_percentage}%;">${memory_percentage}%</div>
        </div>
        <p>Used: $(echo "scale=2; $used_memory/1024/1024" | bc) GB / $(echo "scale=2; $total_memory/1024/1024" | bc) GB</p>
    </div>
    
    <div class="metric">
        <h3>System Load Average</h3>
        <p>1-minute load: $load_avg</p>
    </div>
    
    <div class="metric">
        <h3>Disk Usage</h3>
        <table style="width: 100%; border-collapse: collapse;">
            <tr style="background-color: #f4f4f4;">
                <th style="border: 1px solid #ddd; padding: 8px;">Filesystem</th>
                <th style="border: 1px solid #ddd; padding: 8px;">Size</th>
                <th style="border: 1px solid #ddd; padding: 8px;">Used</th>
                <th style="border: 1px solid #ddd; padding: 8px;">Available</th>
                <th style="border: 1px solid #ddd; padding: 8px;">Use%</th>
                <th style="border: 1px solid #ddd; padding: 8px;">Mounted on</th>
            </tr>
EOF

    df -h | tail -n +2 | while read -r filesystem size used available percentage mountpoint; do
        local color="green"
        local usage_num=${percentage%\%}
        if [ "$usage_num" -gt "$DISK_THRESHOLD" ]; then
            color="red"
        elif [ "$usage_num" -gt 70 ]; then
            color="yellow"
        fi
        
        cat >> "$HTML_REPORT" << EOF
            <tr>
                <td style="border: 1px solid #ddd; padding: 8px;">$filesystem</td>
                <td style="border: 1px solid #ddd; padding: 8px;">$size</td>
                <td style="border: 1px solid #ddd; padding: 8px;">$used</td>
                <td style="border: 1px solid #ddd; padding: 8px;">$available</td>
                <td style="border: 1px solid #ddd; padding: 8px; background-color: $([ "$color" = "red" ] && echo "#f8d7da" || [ "$color" = "yellow" ] && echo "#fff3cd" || echo "#d4edda");">$percentage</td>
                <td style="border: 1px solid #ddd; padding: 8px;">$mountpoint</td>
            </tr>
EOF
    done
    
    cat >> "$HTML_REPORT" << EOF
        </table>
    </div>
    
    <div class="metric">
        <h3>Top Processes by CPU</h3>
        <pre>$(ps aux --sort=-%cpu | head -6)</pre>
    </div>
    
    <div class="metric">
        <h3>Top Processes by Memory</h3>
        <pre>$(ps aux --sort=-%mem | head -6)</pre>
    </div>
</body>
</html>
EOF

    log_message "INFO" "HTML report generated: $HTML_REPORT"
}

# Main monitoring function
run_system_check() {
    local issues=0
    
    echo "System Health Check - $(date)"
    echo "============================="
    
    # Run all checks
    check_cpu_usage || ((issues++))
    check_memory_usage || ((issues++))
    check_disk_usage || ((issues++))
    check_system_load || ((issues++))
    echo
    check_top_processes
    echo
    
    # Generate report
    generate_html_report
    
    # Summary
    if [ $issues -eq 0 ]; then
        log_message "INFO" "System health check completed - no issues found"
        echo -e "${GREEN}✓ System health: OK${NC}"
    else
        log_message "WARN" "System health check completed - $issues issues found"
        echo -e "${YELLOW}⚠ System health: $issues issues found${NC}"
    fi
    
    echo "HTML report: file://$HTML_REPORT"
    echo "Log file: $LOG_FILE"
}

# Script execution
case "${1:-check}" in
    "check"|"")
        run_system_check
        ;;
    "report")
        generate_html_report
        echo "HTML report generated: $HTML_REPORT"
        ;;
    "log")
        if [ -f "$LOG_FILE" ]; then
            tail -20 "$LOG_FILE"
        else
            echo "No log file found"
        fi
        ;;
    *)
        echo "Usage: $0 [check|report|log]"
        echo "  check:  Run system health check (default)"
        echo "  report: Generate HTML report only"
        echo "  log:    Show recent log entries"
        exit 1
        ;;
esac
```

**Explanation:**
- Comprehensive system monitoring with configurable thresholds
- HTML report generation with progress bars and styling
- Structured logging with different log levels
- Color-coded output for better user experience
- Modular design with separate functions for each check

#### Exercise 6: Automated Backup System
**Difficulty:** ⭐⭐ (Intermediate)

Create a backup system that can backup multiple directories with rotation and compression.

**Requirements:**
- Support multiple backup sources
- Implement backup rotation (keep N days)
- Compress backups
- Verify backup integrity
- Email notifications (optional)
- Configuration file support

**Solution:**
```bash
#!/bin/bash

# backup_system.sh - Automated backup system with rotation

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_FILE="$SCRIPT_DIR/backup.conf"
readonly LOG_FILE="$SCRIPT_DIR/backup.log"

# Default configuration
BACKUP_DEST="/backup"
RETENTION_DAYS=7
COMPRESSION="gzip"
VERIFY_BACKUPS=true
EMAIL_NOTIFICATIONS=false
EMAIL_RECIPIENT=""

# Load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        log_message "INFO" "Configuration loaded from $CONFIG_FILE"
    else
        create_default_config
        log_message "INFO" "Default configuration created at $CONFIG_FILE"
    fi
}

# Create default configuration file
create_default_config() {
    cat > "$CONFIG_FILE" << 'EOF'
# Backup System Configuration
# ============================

# Backup destination directory
BACKUP_DEST="/backup"

# Number of days to keep backups
RETENTION_DAYS=7

# Compression method: gzip, bzip2, xz, or none
COMPRESSION="gzip"

# Verify backup integrity after creation
VERIFY_BACKUPS=true

# Email notifications
EMAIL_NOTIFICATIONS=false
EMAIL_RECIPIENT="admin@example.com"

# Backup sources (one per line)
# Format: source_path:backup_name:exclude_patterns
BACKUP_SOURCES=(
    "/home:home_backup:*.tmp,*.log"
    "/etc:system_config:"
    "/var/www:web_data:cache/*,temp/*"
)
EOF
    chmod 600 "$CONFIG_FILE"
}

# Logging function
log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    echo "[$level] $message"
}

# Create backup
create_backup() {
    local source_path=$1
    local backup_name=$2
    local exclude_patterns=$3
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_filename="${backup_name}_${timestamp}"
    
    log_message "INFO" "Starting backup of $source_path as $backup_name"
    
    # Validate source
    if [ ! -d "$source_path" ]; then
        log_message "ERROR" "Source directory not found: $source_path"
        return 1
    fi
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DEST"
    
    # Prepare exclude options
    local exclude_opts=""
    if [ -n "$exclude_patterns" ]; then
        IFS=',' read -ra EXCLUDES <<< "$exclude_patterns"
        for pattern in "${EXCLUDES[@]}"; do
            exclude_opts="$exclude_opts --exclude=$pattern"
        done
    fi
    
    # Create temporary tar file
    local temp_backup="$BACKUP_DEST/${backup_filename}.tar"
    
    log_message "INFO" "Creating tar archive: $temp_backup"
    if tar -cf "$temp_backup" -C "$(dirname "$source_path")" $exclude_opts "$(basename "$source_path")" 2>/dev/null; then
        log_message "INFO" "Tar archive created successfully"
    else
        log_message "ERROR" "Failed to create tar archive"
        rm -f "$temp_backup"
        return 1
    fi
    
    # Compress based on configuration
    local final_backup=""
    case "$COMPRESSION" in
        "gzip")
            final_backup="$BACKUP_DEST/${backup_filename}.tar.gz"
            log_message "INFO" "Compressing with gzip"
            if gzip "$temp_backup"; then
                final_backup="$temp_backup.gz"
                log_message "INFO" "Compression completed"
            else
                log_message "ERROR" "Gzip compression failed"
                rm -f "$temp_backup"
                return 1
            fi
            ;;
        "bzip2")
            final_backup="$BACKUP_DEST/${backup_filename}.tar.bz2"
            log_message "INFO" "Compressing with bzip2"
            if bzip2 "$temp_backup"; then
                final_backup="$temp_backup.bz2"
                log_message "INFO" "Compression completed"
            else
                log_message "ERROR" "Bzip2 compression failed"
                rm -f "$temp_backup"
                return 1
            fi
            ;;
        "xz")
            final_backup="$BACKUP_DEST/${backup_filename}.tar.xz"
            log_message "INFO" "Compressing with xz"
            if xz "$temp_backup"; then
                final_backup="$temp_backup.xz"
                log_message "INFO" "Compression completed"
            else
                log_message "ERROR" "XZ compression failed"
                rm -f "$temp_backup"
                return 1
            fi
            ;;
        "none")
            final_backup="$temp_backup"
            log_message "INFO" "No compression applied"
            ;;
        *)
            log_message "WARN" "Unknown compression method: $COMPRESSION, using gzip"
            final_backup="$BACKUP_DEST/${backup_filename}.tar.gz"
            gzip "$temp_backup"
            final_backup="$temp_backup.gz"
            ;;
    esac
    
    # Verify backup integrity
    if [ "$VERIFY_BACKUPS" = true ]; then
        verify_backup "$final_backup"
    fi
    
    # Get backup size
    local backup_size=$(du -h "$final_backup" | cut -f1)
    log_message "INFO" "Backup completed: $final_backup (Size: $backup_size)"
    
    # Create symlink to latest backup
    local latest_link="$BACKUP_DEST/${backup_name}_latest"
    ln -sf "$(basename "$final_backup")" "$latest_link"
    
    return 0
}

# Verify backup integrity
verify_backup() {
    local backup_file=$1
    
    log_message "INFO" "Verifying backup integrity: $(basename "$backup_file")"
    
    case "$backup_file" in
        *.tar.gz)
            if tar -tzf "$backup_file" >/dev/null 2>&1; then
                log_message "INFO" "Backup verification successful"
                return 0
            else
                log_message "ERROR" "Backup verification failed"
                return 1
            fi
            ;;
        *.tar.bz2)
            if tar -tjf "$backup_file" >/dev/null 2>&1; then
                log_message "INFO" "Backup verification successful"
                return 0
            else
                log_message "ERROR" "Backup verification failed"
                return 1
            fi
            ;;
        *.tar.xz)
            if tar -tJf "$backup_file" >/dev/null 2>&1; then
                log_message "INFO" "Backup verification successful"
                return 0
            else
                log_message "ERROR" "Backup verification failed"
                return 1
            fi
            ;;
        *.tar)
            if tar -tf "$backup_file" >/dev/null 2>&1; then
                log_message "INFO" "Backup verification successful"
                return 0
            else
                log_message "ERROR" "Backup verification failed"
                return 1
            fi
            ;;
    esac
}

# Clean old backups
cleanup_old_backups() {
    log_message "INFO" "Starting cleanup of backups older than $RETENTION_DAYS days"
    
    local deleted_count=0
    local cutoff_date=$(date -d "$RETENTION_DAYS days ago" +%Y%m%d)
    
    for backup_file in "$BACKUP_DEST"/*; do
        if [ -f "$backup_file" ] && [[ "$(basename "$backup_file")" =~ _[0-9]{8}_[0-9]{6}\. ]]; then
            # Extract date from filename
            local file_date=$(basename "$backup_file" | grep -o '[0-9]\{8\}')
            
            if [ -n "$file_date" ] && [ "$file_date" -lt "$cutoff_date" ]; then
                log_message "INFO" "Deleting old backup: $(basename "$backup_file")"
                rm -f "$backup_file"
                ((deleted_count++))
            fi
        fi
    done
    
    log_message "INFO" "Cleanup completed. Deleted $deleted_count old backup(s)"
}

# Send email notification
send_notification() {
    local subject=$1
    local message=$2
    
    if [ "$EMAIL_NOTIFICATIONS" = true ] && [ -n "$EMAIL_RECIPIENT" ]; then
        if command -v mail >/dev/null 2>&1; then
            echo "$message" | mail -s "$subject" "$EMAIL_RECIPIENT"
            log_message "INFO" "Email notification sent to $EMAIL_RECIPIENT"
        else
            log_message "WARN" "Mail command not available, skipping email notification"
        fi
    fi
}

# Main backup function
run_backup() {
    local start_time=$(date +%s)
    local success_count=0
    local error_count=0
    
    log_message "INFO" "Backup process started"
    
    # Load configuration
    load_config
    
    # Process each backup source
    for source_config in "${BACKUP_SOURCES[@]}"; do
        IFS=':' read -r source_path backup_name exclude_patterns <<< "$source_config"
        
        if create_backup "$source_path" "$backup_name" "$exclude_patterns"; then
            ((success_count++))
        else
            ((error_count++))
        fi
    done
    
    # Cleanup old backups
    cleanup_old_backups
    
    # Calculate duration
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Summary
    local summary="Backup Summary:\n"
    summary+="- Successful backups: $success_count\n"
    summary+="- Failed backups: $error_count\n"
    summary+="- Duration: ${duration}s\n"
    summary+="- Log file: $LOG_FILE"
    
    log_message "INFO" "Backup process completed"
    echo -e "$summary"
    
    # Send notification
    if [ $error_count -eq 0 ]; then
        send_notification "Backup Successful" "$summary"
    else
        send_notification "Backup Completed with Errors" "$summary"
    fi
}

# List backups
list_backups() {
    echo "Available Backups:"
    echo "=================="
    
    if [ ! -d "$BACKUP_DEST" ]; then
        echo "No backup directory found: $BACKUP_DEST"
        return 1
    fi
    
    ls -lh "$BACKUP_DEST"/*.tar* 2>/dev/null | while read -r perms links owner group size month day time filename; do
        local basename=$(basename "$filename")
        local backup_name=$(echo "$basename" | sed 's/_[0-9]\{8\}_[0-9]\{6\}\..*$//')
        local backup_date=$(echo "$basename" | grep -o '[0-9]\{8\}_[0-9]\{6\}' | sed 's/_/ /')
        
        printf "%-20s %s %10s %s\n" "$backup_name" "$backup_date" "$size" "$basename"
    done
}

# Restore backup
restore_backup() {
    local backup_file=$1
    local restore_path=${2:-"/tmp/restore"}
    
    if [ ! -f "$BACKUP_DEST/$backup_file" ]; then
        log_message "ERROR" "Backup file not found: $backup_file"
        return 1
    fi
    
    mkdir -p "$restore_path"
    local full_backup_path="$BACKUP_DEST/$backup_file"
    
    log_message "INFO" "Restoring backup: $backup_file to $restore_path"
    
    case "$backup_file" in
        *.tar.gz)
            tar -xzf "$full_backup_path" -C "$restore_path"
            ;;
        *.tar.bz2)
            tar -xjf "$full_backup_path" -C "$restore_path"
            ;;
        *.tar.xz)
            tar -xJf "$full_backup_path" -C "$restore_path"
            ;;
        *.tar)
            tar -xf "$full_backup_path" -C "$restore_path"
            ;;
        *)
            log_message "ERROR" "Unknown backup format: $backup_file"
            return 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        log_message "INFO" "Restore completed successfully to $restore_path"
        return 0
    else
        log_message "ERROR" "Restore failed"
        return 1
    fi
}

# Main script execution
case "${1:-backup}" in
    "backup"|"")
        run_backup
        ;;
    "list")
        load_config
        list_backups
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo "Usage: $0 restore <backup_filename> [restore_path]"
            exit 1
        fi
        load_config
        restore_backup "$2" "$3"
        ;;
    "config")
        create_default_config
        echo "Configuration file created: $CONFIG_FILE"
        ;;
    "log")
        if [ -f "$LOG_FILE" ]; then
            tail -20 "$LOG_FILE"
        else
            echo "No log file found"
        fi
        ;;
    *)
        echo "Usage: $0 [backup|list|restore|config|log]"
        echo "  backup:             Run backup process (default)"
        echo "  list:               List available backups"
        echo "  restore <file>:     Restore specific backup"
        echo "  config:             Create default configuration"
        echo "  log:                Show recent log entries"
        exit 1
        ;;
esac
```

**Explanation:**
- Configuration file system for flexible backup management
- Multiple compression format support
- Backup verification and integrity checking
- Automated cleanup with configurable retention
- Email notification system
- Restore functionality with different target locations
- Comprehensive logging throughout the process

This comprehensive practice guide provides progressive exercises from beginner to advanced levels, with detailed solutions and explanations. Each exercise builds upon previous concepts while introducing new techniques and best practices.
