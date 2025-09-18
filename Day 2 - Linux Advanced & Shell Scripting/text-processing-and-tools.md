# Comprehensive Text Processing and Tools Guide

## Table of Contents
1. [Introduction to Text Processing](#introduction-to-text-processing)
2. [grep - Pattern Searching](#grep---pattern-searching)
3. [sed - Stream Editor](#sed---stream-editor)
4. [awk - Pattern-Action Processing](#awk---pattern-action-processing)
5. [cut - Field Extraction](#cut---field-extraction)
6. [sort - Text Sorting](#sort---text-sorting)
7. [uniq - Duplicate Handling](#uniq---duplicate-handling)
8. [tr - Character Translation](#tr---character-translation)
9. [Regular Expressions](#regular-expressions)
10. [Advanced Text Processing](#advanced-text-processing)
11. [Performance Optimization](#performance-optimization)
12. [Real-World Examples](#real-world-examples)

## Introduction to Text Processing

Linux provides a comprehensive suite of command-line tools for processing text data. These tools follow the Unix philosophy: "Do one thing and do it well" and can be combined using pipes to create powerful text processing pipelines.

### Core Concepts

- **Streams:** Text data flows through commands as streams
- **Pipes:** Connect output of one command to input of another
- **Regular Expressions:** Pattern matching language
- **Field Separation:** Splitting text into columns/fields
- **Line-oriented Processing:** Most tools process text line by line

### Common Data Formats

- **Structured:** CSV, TSV, fixed-width columns
- **Semi-structured:** Log files, configuration files
- **Unstructured:** Natural language text
- **Mixed:** HTML, XML with text content

## grep - Pattern Searching

### Basic Usage and Options

```bash
# Basic pattern matching
grep "pattern" file.txt
grep "error" /var/log/syslog

# Case-insensitive search
grep -i "ERROR" logfile.txt

# Invert match (show non-matching lines)
grep -v "debug" application.log

# Show line numbers
grep -n "TODO" source.py

# Count matching lines
grep -c "failed" auth.log

# Show only filenames with matches
grep -l "main" *.py

# Show filenames without matches
grep -L "test" *.js

# Recursive search
grep -r "function" /path/to/source/
grep -R "class" --include="*.py" /project/

# Word boundary matching
grep -w "cat" animals.txt    # Matches "cat" but not "category"

# Show context around matches
grep -B 2 -A 2 "error" log.txt  # 2 lines before and after
grep -C 3 "exception" log.txt    # 3 lines of context
```

### Advanced grep Techniques

```bash
# Multiple patterns with OR
grep -E "error|warning|critical" logfile.txt
grep "error\|warning\|critical" logfile.txt

# Multiple patterns with AND (using pipes)
grep "database" logfile.txt | grep "connection"

# Pattern from file
echo -e "error\nwarning\ncritical" > patterns.txt
grep -f patterns.txt logfile.txt

# Binary files
grep -a "string" binaryfile     # Treat binary as text
grep -I "pattern" *             # Skip binary files

# Fixed strings (no regex)
grep -F "special.chars[]*" file.txt
fgrep "literal.string" file.txt

# Perl-compatible regex
grep -P "\d{3}-\d{2}-\d{4}" ssn.txt  # Social security pattern

# Color highlighting
grep --color=always "pattern" file.txt | less -R

# Performance optimization
grep -F -f large_pattern_file.txt large_data_file.txt  # Fixed strings faster
```

### grep in Scripts

```bash
#!/bin/bash

# Function to search log files with error analysis
analyze_logs() {
    local log_file=$1
    local time_period=${2:-"today"}
    
    case $time_period in
        "today")
            date_pattern=$(date +%Y-%m-%d)
            ;;
        "yesterday") 
            date_pattern=$(date -d yesterday +%Y-%m-%d)
            ;;
        "week")
            # Last 7 days
            for i in {0..6}; do
                date -d "$i days ago" +%Y-%m-%d
            done > /tmp/date_patterns
            ;;
    esac
    
    echo "Log Analysis Report - $time_period"
    echo "=================================="
    
    # Error count
    if [ "$time_period" = "week" ]; then
        error_count=$(grep -F -f /tmp/date_patterns "$log_file" | grep -c -i error)
    else
        error_count=$(grep "$date_pattern" "$log_file" | grep -c -i error)
    fi
    
    echo "Total errors: $error_count"
    
    # Top error types
    echo -e "\nTop Error Types:"
    if [ "$time_period" = "week" ]; then
        grep -F -f /tmp/date_patterns "$log_file" | grep -i error | \
        awk '{print $5}' | sort | uniq -c | sort -rn | head -5
    else
        grep "$date_pattern" "$log_file" | grep -i error | \
        awk '{print $5}' | sort | uniq -c | sort -rn | head -5
    fi
    
    # Recent errors
    echo -e "\nRecent Errors:"
    if [ "$time_period" = "week" ]; then
        grep -F -f /tmp/date_patterns "$log_file" | grep -i error | tail -5
    else
        grep "$date_pattern" "$log_file" | grep -i error | tail -5
    fi
    
    # Cleanup
    [ -f /tmp/date_patterns ] && rm /tmp/date_patterns
}

# Function for intelligent pattern searching
smart_search() {
    local pattern=$1
    local directory=${2:-.}
    local file_types=${3:-"*"}
    
    echo "Smart Search Results for: $pattern"
    echo "=================================="
    
    # Exact matches
    echo "Exact matches:"
    grep -rn --include="$file_types" "$pattern" "$directory" 2>/dev/null | head -5
    
    # Case-insensitive matches
    echo -e "\nCase-insensitive matches:"
    grep -rin --include="$file_types" "$pattern" "$directory" 2>/dev/null | head -5
    
    # Word boundary matches
    echo -e "\nWord boundary matches:"
    grep -rnw --include="$file_types" "$pattern" "$directory" 2>/dev/null | head -5
    
    # Fuzzy matches (similar words)
    echo -e "\nSimilar patterns:"
    grep -rin --include="$file_types" ".*${pattern}.*" "$directory" 2>/dev/null | head -5
}
```

## sed - Stream Editor

### Basic sed Operations

```bash
# Substitute (replace) text
sed 's/old/new/' file.txt              # Replace first occurrence per line
sed 's/old/new/g' file.txt             # Replace all occurrences
sed 's/old/new/2' file.txt             # Replace second occurrence per line

# Case-insensitive replacement
sed 's/old/new/gi' file.txt

# In-place editing
sed -i 's/old/new/g' file.txt          # Modify file directly
sed -i.bak 's/old/new/g' file.txt      # Create backup

# Delete lines
sed '3d' file.txt                      # Delete line 3
sed '2,5d' file.txt                    # Delete lines 2-5
sed '/pattern/d' file.txt              # Delete lines matching pattern
sed '/^$/d' file.txt                   # Delete empty lines

# Print specific lines
sed -n '5p' file.txt                   # Print only line 5
sed -n '1,3p' file.txt                 # Print lines 1-3
sed -n '/pattern/p' file.txt           # Print lines matching pattern

# Insert and append text
sed '2i\New line before line 2' file.txt
sed '2a\New line after line 2' file.txt
sed '/pattern/a\Text after matching line' file.txt

# Multiple operations
sed -e 's/foo/bar/g' -e 's/hello/hi/g' file.txt
```

### Advanced sed Techniques

```bash
# Address ranges and patterns
sed '10,20s/old/new/g' file.txt       # Replace in lines 10-20
sed '/start/,/end/s/old/new/g' file.txt  # Replace between patterns

# Hold space operations
sed -n '1!G;h;$p' file.txt             # Reverse file (tac equivalent)

# Branching and labels
sed ':a;N;$!ba;s/\n/ /g' file.txt      # Join all lines with spaces

# Working with delimiters
sed 's|/old/path|/new/path|g' file.txt # Use | as delimiter
sed 's#old#new#g' file.txt             # Use # as delimiter

# Multiple files
sed 's/old/new/g' file1.txt file2.txt  # Process multiple files

# Complex pattern replacement
sed 's/\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/IP:\1-\2-\3-\4/g' file.txt

# Conditional operations
sed '/pattern/s/old/new/g' file.txt    # Replace only on matching lines
sed '/pattern/!s/old/new/g' file.txt   # Replace only on non-matching lines
```

### sed Scripting

```bash
#!/bin/bash

# Function to clean and format log files
clean_log_file() {
    local input_file=$1
    local output_file=${2:-"${input_file}.cleaned"}
    
    sed '
        # Remove empty lines
        /^$/d
        
        # Remove debug messages
        /DEBUG/d
        
        # Standardize timestamp format
        s/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)T\([0-9]\{2\}\):\([0-9]\{2\}\):\([0-9]\{2\}\)/\1\/\2\/\3 \4:\5:\6/g
        
        # Convert log levels to uppercase
        s/\<info\>/INFO/gi
        s/\<warn\>/WARN/gi
        s/\<error\>/ERROR/gi
        
        # Remove sensitive information (IP addresses)
        s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/XXX.XXX.XXX.XXX/g
        
        # Add line numbers
        =' "$input_file" | sed 'N;s/\n/: /' > "$output_file"
    
    echo "Log file cleaned: $input_file -> $output_file"
}

# Function to format configuration files
format_config() {
    local config_file=$1
    local backup_file="${config_file}.backup"
    
    # Create backup
    cp "$config_file" "$backup_file"
    
    sed -i '
        # Remove trailing whitespace
        s/[[:space:]]*$//
        
        # Remove comments and empty lines
        /^[[:space:]]*#/d
        /^[[:space:]]*$/d
        
        # Standardize key=value format
        s/[[:space:]]*=[[:space:]]*/=/g
        
        # Convert keys to lowercase
        s/^\([A-Z_]*\)=/\L\1=/g
        
        # Sort configuration sections (simple approach)
        # This would need more complex sed for real sorting
    ' "$config_file"
    
    echo "Configuration formatted: $config_file"
    echo "Backup created: $backup_file"
}

# CSV processing with sed
process_csv() {
    local csv_file=$1
    local output_file=${2:-"processed_${csv_file}"}
    
    sed '
        # Skip header line for processing
        1b skip
        
        # Remove quotes around fields
        s/"//g
        
        # Convert dates from MM/DD/YYYY to YYYY-MM-DD
        s/\([0-9]\{1,2\}\)\/\([0-9]\{1,2\}\)\/\([0-9]\{4\}\)/\3-\1-\2/g
        
        # Uppercase specific fields (assuming 3rd field)
        s/^\([^,]*,[^,]*,\)\([^,]*\)/\1\U\2/
        
        :skip
    ' "$csv_file" > "$output_file"
    
    echo "CSV processed: $csv_file -> $output_file"
}
```

## awk - Pattern-Action Processing

### awk Fundamentals

```bash
# Basic syntax: awk 'pattern { action }' file

# Print entire file
awk '{ print }' file.txt
awk '{ print $0 }' file.txt            # $0 is the entire line

# Print specific fields
awk '{ print $1 }' file.txt            # First field
awk '{ print $1, $3 }' file.txt        # First and third fields
awk '{ print $NF }' file.txt           # Last field
awk '{ print $(NF-1) }' file.txt       # Second-to-last field

# Field separator
awk -F: '{ print $1, $3 }' /etc/passwd # Use colon as separator
awk 'BEGIN { FS=":" } { print $1, $3 }' /etc/passwd

# Output field separator
awk 'BEGIN { OFS="|" } { print $1, $2, $3 }' file.txt

# Print line numbers
awk '{ print NR, $0 }' file.txt

# Print number of fields per line
awk '{ print NF, $0 }' file.txt
```

### awk Variables and Built-ins

```bash
# Built-in variables
# NR  - Number of records (lines) processed
# NF  - Number of fields in current record
# FS  - Field separator (input)
# OFS - Output field separator
# RS  - Record separator (input)
# ORS - Output record separator
# FILENAME - Name of current file

# Examples using built-in variables
awk 'END { print "Total lines:", NR }' file.txt
awk '{ print "Line " NR " has " NF " fields" }' file.txt
awk 'NF > 5 { print $0 }' file.txt     # Lines with more than 5 fields

# Custom variables
awk '{ sum += $1 } END { print "Sum:", sum }' numbers.txt
awk '{ count++ } END { print "Count:", count }' file.txt
```

### awk Patterns and Conditions

```bash
# Pattern matching
awk '/error/ { print $0 }' logfile.txt        # Lines containing "error"
awk '/^[0-9]/ { print $1 }' file.txt          # Lines starting with digit

# Numeric conditions
awk '$3 > 50 { print $1, $3 }' data.txt       # Third field > 50
awk '$2 >= 1000 && $2 <= 5000 { print }' file.txt

# String conditions
awk '$1 == "admin" { print $2 }' users.txt
awk '$4 ~ /^[A-Z]/ { print }' file.txt        # Fourth field starts with uppercase

# Range patterns
awk '/START/,/END/ { print }' file.txt        # Lines between START and END

# Multiple conditions
awk '$1 == "ERROR" || $1 == "WARN" { print $0 }' log.txt
awk '$3 > 100 && $4 < 200 { count++ } END { print count }' data.txt
```

### Advanced awk Programming

```bash
# awk functions
awk '
function max(a, b) { return a > b ? a : b }
{ maximum = max(maximum, $1) }
END { print "Maximum:", maximum }
' numbers.txt

# Arrays in awk
awk '
{ 
    count[$1]++ 
} 
END { 
    for (item in count) 
        print item, count[item] 
}' data.txt

# String functions
awk '{ print length($1), substr($1, 1, 3), toupper($2) }' file.txt

# Math functions
awk '{ print sqrt($1), int($2), rand() }' numbers.txt

# Multiple files processing
awk '
FNR == 1 { print "Processing:", FILENAME }
{ print $1 }
' file1.txt file2.txt

# BEGIN and END blocks
awk '
BEGIN { 
    print "Starting processing..."
    FS = ","
    OFS = " | "
    total = 0
}
{ 
    total += $3
    print $1, $2, $3 
}
END { 
    print "Total:", total
    print "Average:", total/NR
}' data.csv
```

### awk Scripting

```bash
#!/bin/bash

# Function to analyze web server logs
analyze_web_logs() {
    local log_file=$1
    
    awk '
    BEGIN {
        print "Web Server Log Analysis"
        print "======================="
    }
    {
        # Common log format: IP - - [timestamp] "method url protocol" status size
        ip = $1
        method = $6
        url = $7
        status = $9
        size = $10
        
        # Remove quotes and brackets
        gsub(/["\[\]]/, "", method)
        gsub(/["\[\]]/, "", url)
        
        # Count requests per IP
        ip_count[ip]++
        
        # Count HTTP methods
        method_count[method]++
        
        # Count status codes
        status_count[status]++
        
        # Track total bytes
        if (size != "-" && size > 0) {
            total_bytes += size
            byte_count++
        }
        
        # Track URLs
        url_count[url]++
    }
    END {
        print "\nTop 10 IP Addresses:"
        PROCINFO["sorted_in"] = "@val_num_desc"
        count = 0
        for (ip in ip_count) {
            if (++count <= 10) {
                printf "%-15s: %d requests\n", ip, ip_count[ip]
            }
        }
        
        print "\nHTTP Methods:"
        for (method in method_count) {
            printf "%-10s: %d\n", method, method_count[method]
        }
        
        print "\nStatus Codes:"
        for (status in status_count) {
            printf "%-5s: %d\n", status, status_count[status]
        }
        
        print "\nTop 10 URLs:"
        PROCINFO["sorted_in"] = "@val_num_desc"
        count = 0
        for (url in url_count) {
            if (++count <= 10) {
                printf "%-30s: %d\n", url, url_count[url]
            }
        }
        
        if (byte_count > 0) {
            printf "\nAverage response size: %.2f bytes\n", total_bytes/byte_count
            printf "Total bytes transferred: %d\n", total_bytes
        }
    }' "$log_file"
}

# Function to process CSV data
process_sales_data() {
    local csv_file=$1
    
    awk -F, '
    BEGIN {
        print "Sales Data Analysis"
        print "=================="
        OFS = "\t"
    }
    NR == 1 {
        # Print header
        print $0
        next
    }
    {
        # Assuming columns: Date, Product, Quantity, Price, Total
        date = $1
        product = $2
        quantity = $3
        price = $4
        total = $5
        
        # Monthly sales
        month = substr(date, 1, 7)  # YYYY-MM format
        monthly_sales[month] += total
        
        # Product sales
        product_sales[product] += total
        product_quantity[product] += quantity
        
        # Daily totals
        daily_sales[date] += total
        
        grand_total += total
        total_quantity += quantity
        record_count++
    }
    END {
        print "\nSummary:"
        printf "Total Sales: $%.2f\n", grand_total
        printf "Total Quantity: %d\n", total_quantity
        printf "Number of Transactions: %d\n", record_count
        printf "Average Transaction: $%.2f\n", grand_total/record_count
        
        print "\nMonthly Sales:"
        for (month in monthly_sales) {
            printf "%s: $%.2f\n", month, monthly_sales[month]
        }
        
        print "\nTop Products:"
        PROCINFO["sorted_in"] = "@val_num_desc"
        count = 0
        for (product in product_sales) {
            if (++count <= 5) {
                printf "%-20s: $%.2f (%d units)\n", product, product_sales[product], product_quantity[product]
            }
        }
    }' "$csv_file"
}
```

## cut - Field Extraction

### Basic cut Operations

```bash
# Extract by character position
cut -c 1-5 file.txt                    # Characters 1-5
cut -c 1,3,5 file.txt                  # Characters 1, 3, and 5
cut -c 10- file.txt                    # From character 10 to end

# Extract by byte position
cut -b 1-10 file.txt                   # Bytes 1-10 (useful for multi-byte chars)

# Extract fields (default delimiter: tab)
cut -f 1 file.txt                      # First field
cut -f 1,3 file.txt                    # First and third fields
cut -f 1-3 file.txt                    # Fields 1 through 3

# Custom delimiter
cut -d: -f 1,3 /etc/passwd             # Fields 1 and 3, colon-separated
cut -d, -f 2-4 data.csv                # CSV fields 2-4

# Multiple delimiters (use tr first)
tr ' \t' ':' < file.txt | cut -d: -f 1,2

# Complement (everything except specified fields)
cut --complement -f 2 file.txt         # All fields except second

# Only show lines with delimiter
cut -s -d: -f 1 /etc/passwd            # Skip lines without colon
```

### Advanced cut Usage

```bash
#!/bin/bash

# Function to extract specific columns from various file formats
extract_columns() {
    local file=$1
    local columns=$2
    local format=${3:-"auto"}
    
    case $format in
        "csv")
            cut -d, -f "$columns" "$file"
            ;;
        "tsv"|"tab")
            cut -f "$columns" "$file"
            ;;
        "fixed")
            # For fixed-width files, need to specify character positions
            # Example: positions 1-10, 15-25, 30-40
            cut -c 1-10,15-25,30-40 "$file"
            ;;
        "auto")
            # Auto-detect format
            if grep -q ',' "$file" | head -5; then
                echo "Detected CSV format"
                cut -d, -f "$columns" "$file"
            elif grep -q $'\t' "$file" | head -5; then
                echo "Detected TSV format"
                cut -f "$columns" "$file"
            else
                echo "Assuming space-separated format"
                tr -s ' ' '\t' < "$file" | cut -f "$columns"
            fi
            ;;
    esac
}

# Function to create summary from log files
log_summary() {
    local log_file=$1
    
    echo "Log File Summary: $log_file"
    echo "==========================="
    
    # Extract timestamps (assuming first 19 characters are timestamp)
    echo "First entry: $(head -1 "$log_file" | cut -c 1-19)"
    echo "Last entry:  $(tail -1 "$log_file" | cut -c 1-19)"
    
    # Extract log levels (assuming 5th field space-separated)
    echo -e "\nLog Levels:"
    tr -s ' ' '\t' < "$log_file" | cut -f 5 | sort | uniq -c | sort -rn
    
    # Extract unique IPs (assuming they're in various positions)
    echo -e "\nUnique IP Addresses:"
    grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$log_file" | sort | uniq -c | sort -rn | head -10
}

# Function to process employee data
process_employee_data() {
    local employee_file=$1  # Format: ID,Name,Department,Salary
    
    echo "Employee Data Processing"
    echo "======================="
    
    # Extract names and departments
    echo "Employees by Department:"
    cut -d, -f 2,3 "$employee_file" | tail -n +2 | sort -t, -k2,2
    
    # Extract salaries for analysis
    echo -e "\nSalary Statistics:"
    salaries=$(cut -d, -f 4 "$employee_file" | tail -n +2)
    
    total=$(echo "$salaries" | awk '{sum += $1} END {print sum}')
    count=$(echo "$salaries" | wc -l)
    average=$(echo "scale=2; $total / $count" | bc)
    
    echo "Total employees: $count"
    echo "Total salary budget: \$$(echo $total | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')"
    echo "Average salary: \$$(echo $average | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')"
}
```

## sort - Text Sorting

### Basic Sorting Operations

```bash
# Simple alphabetical sort
sort file.txt
sort < file.txt > sorted.txt

# Reverse sort
sort -r file.txt

# Numeric sort
sort -n numbers.txt                     # Sort numerically
sort -nr numbers.txt                    # Reverse numeric sort

# Sort by specific field
sort -k 2 file.txt                      # Sort by second field
sort -k 2,2 file.txt                    # Sort by second field only
sort -t: -k 3 -n /etc/passwd            # Numeric sort by field 3, colon-separated

# Multiple sort keys
sort -k 2,2 -k 1,1 file.txt            # Sort by field 2, then field 1

# Case-insensitive sort
sort -f file.txt
sort --ignore-case file.txt

# Ignore leading blanks
sort -b file.txt

# Sort by month
sort -M months.txt                      # Jan, Feb, Mar, etc.

# Human-readable numeric sort
sort -h file_sizes.txt                  # Handles K, M, G suffixes

# Unique sort
sort -u file.txt                        # Remove duplicates while sorting

# Check if file is sorted
sort -c file.txt                        # Check, exit with error if not sorted
sort -C file.txt                        # Check silently
```

### Advanced Sorting Techniques

```bash
# Complex field sorting
sort -t, -k 3,3n -k 1,1 data.csv       # Numeric sort by field 3, then alphabetic by field 1

# Sort by specific character positions
sort -k 1.5,1.8 file.txt               # Sort by characters 5-8 of first field

# Reverse specific fields
sort -k 1,1 -k 2,2r file.txt           # Sort field 1 ascending, field 2 descending

# Random sort (shuffle)
sort -R file.txt
shuf file.txt                           # Alternative command for shuffling

# Merge sorted files
sort -m sorted1.txt sorted2.txt         # Merge pre-sorted files

# Sort in parallel (faster for large files)
sort --parallel=4 large_file.txt

# Custom locale sorting
LC_COLLATE=C sort file.txt              # ASCII sort order
```

### Sorting Scripts and Functions

```bash
#!/bin/bash

# Function to sort log files by timestamp
sort_logs_by_time() {
    local log_file=$1
    local output_file=${2:-"${log_file}.sorted"}
    
    # Assuming timestamp is in format YYYY-MM-DD HH:MM:SS at beginning of line
    sort -k 1,1 -k 2,2 "$log_file" > "$output_file"
    
    echo "Log file sorted by timestamp: $output_file"
}

# Function to sort CSV files with multiple criteria
sort_csv_data() {
    local csv_file=$1
    local sort_columns=$2  # e.g., "3n,1,2r" means col 3 numeric, col 1 asc, col 2 desc
    local has_header=${3:-true}
    
    if [ "$has_header" = "true" ]; then
        # Sort with header preservation
        (head -1 "$csv_file"; tail -n +2 "$csv_file" | sort -t, -k "$sort_columns") > "${csv_file}.sorted"
    else
        sort -t, -k "$sort_columns" "$csv_file" > "${csv_file}.sorted"
    fi
    
    echo "CSV sorted: ${csv_file}.sorted"
}

# Function to sort files by size within directories
sort_files_by_size() {
    local directory=${1:-.}
    local reverse=${2:-false}
    
    echo "Files in $directory sorted by size:"
    echo "=================================="
    
    if [ "$reverse" = "true" ]; then
        find "$directory" -type f -exec ls -la {} \; | sort -k5,5nr
    else
        find "$directory" -type f -exec ls -la {} \; | sort -k5,5n
    fi
}

# Function to sort and analyze data distribution
analyze_data_distribution() {
    local data_file=$1
    local field=${2:-1}
    
    echo "Data Distribution Analysis"
    echo "========================="
    
    # Sort and count occurrences
    cut -f "$field" "$data_file" | sort | uniq -c | sort -nr > distribution.txt
    
    echo "Top 10 most frequent values:"
    head -10 distribution.txt
    
    echo -e "\nLeast frequent values:"
    tail -10 distribution.txt
    
    # Statistics
    total_unique=$(wc -l < distribution.txt)
    total_records=$(cut -f "$field" "$data_file" | wc -l)
    
    echo -e "\nStatistics:"
    echo "Unique values: $total_unique"
    echo "Total records: $total_records"
    echo "Uniqueness ratio: $(echo "scale=2; $total_unique / $total_records * 100" | bc)%"
    
    rm distribution.txt
}
```

## uniq - Duplicate Handling

### Basic uniq Operations

```bash
# Remove duplicate lines (requires sorted input)
sort file.txt | uniq

# Count occurrences
sort file.txt | uniq -c

# Show only duplicate lines
sort file.txt | uniq -d

# Show only unique lines (no duplicates)
sort file.txt | uniq -u

# Ignore case when comparing
sort file.txt | uniq -i

# Skip first N characters
sort file.txt | uniq -s 5

# Compare only first N characters
sort file.txt | uniq -w 10

# Skip first N fields
sort file.txt | uniq -f 2
```

### Advanced uniq Usage

```bash
#!/bin/bash

# Function to analyze duplicate patterns in logs
analyze_log_duplicates() {
    local log_file=$1
    local field_to_check=${2:-1}  # Which field to check for duplicates
    
    echo "Duplicate Analysis for: $log_file"
    echo "================================="
    
    # Count duplicate log entries
    echo "Most frequent log entries:"
    sort "$log_file" | uniq -c | sort -nr | head -10
    
    # Find entries that appear more than N times
    local threshold=${3:-5}
    echo -e "\nEntries appearing more than $threshold times:"
    sort "$log_file" | uniq -c | awk -v threshold="$threshold" '$1 > threshold {print $0}'
    
    # Analyze specific field duplicates
    echo -e "\nMost frequent values in field $field_to_check:"
    awk -v field="$field_to_check" '{print $field}' "$log_file" | sort | uniq -c | sort -nr | head -10
}

# Function to clean duplicate data from CSV
clean_csv_duplicates() {
    local csv_file=$1
    local key_fields=${2:-"1,2"}  # Fields to consider for duplicates
    local keep_header=${3:-true}
    
    echo "Cleaning duplicates from: $csv_file"
    
    if [ "$keep_header" = "true" ]; then
        # Keep header and process data
        head -1 "$csv_file" > "${csv_file}.clean"
        tail -n +2 "$csv_file" | sort -t, -k "$key_fields" | uniq >> "${csv_file}.clean"
    else
        sort -t, -k "$key_fields" "$csv_file" | uniq > "${csv_file}.clean"
    fi
    
    local original_lines=$(wc -l < "$csv_file")
    local clean_lines=$(wc -l < "${csv_file}.clean")
    local duplicates_removed=$((original_lines - clean_lines))
    
    echo "Original lines: $original_lines"
    echo "Clean lines: $clean_lines"
    echo "Duplicates removed: $duplicates_removed"
    echo "Clean file: ${csv_file}.clean"
}

# Function to find unique patterns in text
find_unique_patterns() {
    local text_file=$1
    local pattern_type=${2:-"words"}
    
    case $pattern_type in
        "words")
            # Find unique words
            tr ' ' '\n' < "$text_file" | tr -d '[:punct:]' | tr '[:upper:]' '[:lower:]' | sort | uniq -u
            ;;
        "lines")
            # Find unique lines
            sort "$text_file" | uniq -u
            ;;
        "emails")
            # Find unique email addresses
            grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$text_file" | sort | uniq
            ;;
        "ips")
            # Find unique IP addresses
            grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$text_file" | sort | uniq
            ;;
    esac
}
```

## tr - Character Translation

### Basic tr Operations

```bash
# Character replacement
tr 'a' 'b' < file.txt                  # Replace 'a' with 'b'
tr 'abc' 'xyz' < file.txt              # Replace a->x, b->y, c->z

# Case conversion
tr '[:lower:]' '[:upper:]' < file.txt  # Convert to uppercase
tr '[:upper:]' '[:lower:]' < file.txt  # Convert to lowercase

# Delete characters
tr -d 'aeiou' < file.txt               # Delete vowels
tr -d '[:punct:]' < file.txt           # Delete punctuation
tr -d '[:space:]' < file.txt           # Delete all whitespace

# Squeeze repeated characters
tr -s ' ' < file.txt                   # Squeeze multiple spaces to single space
tr -s '\n' < file.txt                  # Remove empty lines

# Complement (work with everything except specified chars)
tr -c '[:alnum:]' ' ' < file.txt       # Replace non-alphanumeric with spaces

# Character ranges
tr 'a-z' 'A-Z' < file.txt              # Lowercase to uppercase
tr '0-9' '*' < file.txt                # Replace digits with asterisks
```

### Advanced tr Applications

```bash
#!/bin/bash

# Function to clean and standardize text data
clean_text_data() {
    local input_file=$1
    local output_file=${2:-"${input_file}.clean"}
    
    echo "Cleaning text data: $input_file"
    
    # Multi-step cleaning pipeline
    tr '[:upper:]' '[:lower:]' < "$input_file" |    # Convert to lowercase
    tr -d '[:cntrl:]' |                              # Remove control characters
    tr -s '[:space:]' ' ' |                          # Squeeze whitespace
    tr -d '[:punct:]' |                              # Remove punctuation
    tr -s '\n' > "$output_file"                      # Squeeze newlines
    
    echo "Cleaned data saved to: $output_file"
}

# Function to normalize CSV data
normalize_csv() {
    local csv_file=$1
    local output_file=${2:-"${csv_file}.normalized"}
    
    echo "Normalizing CSV: $csv_file"
    
    # Remove carriage returns, normalize quotes, squeeze spaces
    tr -d '\r' < "$csv_file" |           # Remove Windows line endings
    tr -s ' \t' ' ' |                    # Normalize whitespace
    tr -d '\000-\031' |                  # Remove non-printable characters
    tr -s '\n' > "$output_file"          # Ensure single newlines
    
    echo "Normalized CSV: $output_file"
}

# Function to create character frequency analysis
char_frequency_analysis() {
    local text_file=$1
    
    echo "Character Frequency Analysis: $text_file"
    echo "========================================"
    
    # Convert to lowercase and analyze character frequency
    tr '[:upper:]' '[:lower:]' < "$text_file" | 
    tr -d '[:space:][:punct:][:digit:]' |
    fold -w1 |                          # Split into one character per line
    sort | uniq -c | sort -nr |
    head -20
}

# Function to convert data formats
convert_data_format() {
    local input_file=$1
    local format_type=$2
    local output_file=${3:-"${input_file}.converted"}
    
    case $format_type in
        "csv_to_tsv")
            tr ',' '\t' < "$input_file" > "$output_file"
            echo "Converted CSV to TSV: $output_file"
            ;;
        "tsv_to_csv")
            tr '\t' ',' < "$input_file" > "$output_file"
            echo "Converted TSV to CSV: $output_file"
            ;;
        "spaces_to_tabs")
            tr -s ' ' '\t' < "$input_file" > "$output_file"
            echo "Converted spaces to tabs: $output_file"
            ;;
        "tabs_to_spaces")
            tr '\t' ' ' < "$input_file" > "$output_file"
            echo "Converted tabs to spaces: $output_file"
            ;;
        "remove_non_ascii")
            tr -cd '[:print:][:space:]' < "$input_file" > "$output_file"
            echo "Removed non-ASCII characters: $output_file"
            ;;
    esac
}
```

By mastering `grep`, `sed`, and `awk`, you can perform complex text manipulation and data extraction tasks directly from the command line.

## Regular Expressions

Regular expressions (regex) are patterns used to match character combinations in strings. They're essential for advanced text processing.

### Basic Regex Patterns

```bash
# Literal characters
grep "hello" file.txt                   # Match exact string "hello"

# Metacharacters
grep "." file.txt                       # Match any single character
grep "^start" file.txt                  # Match lines starting with "start"
grep "end$" file.txt                    # Match lines ending with "end"

# Character classes
grep "[abc]" file.txt                   # Match a, b, or c
grep "[a-z]" file.txt                   # Match any lowercase letter
grep "[^0-9]" file.txt                  # Match any non-digit
grep "[[:digit:]]" file.txt             # Match any digit (POSIX)
grep "[[:alpha:]]" file.txt             # Match any letter

# Quantifiers
grep "a*" file.txt                      # Match 0 or more 'a's
grep "a\+" file.txt                     # Match 1 or more 'a's (basic regex)
grep "a?" file.txt                      # Match 0 or 1 'a' (extended regex)
grep "a\{3\}" file.txt                  # Match exactly 3 'a's
grep "a\{2,5\}" file.txt                # Match 2 to 5 'a's
```

### Extended Regular Expressions

```bash
# Use -E flag for extended regex or egrep
grep -E "a+" file.txt                   # 1 or more 'a's
grep -E "a?" file.txt                   # 0 or 1 'a'
grep -E "a{3}" file.txt                 # Exactly 3 'a's
grep -E "a{2,5}" file.txt               # 2 to 5 'a's

# Alternation
grep -E "(cat|dog)" file.txt            # Match "cat" or "dog"
grep -E "colou?r" file.txt              # Match "color" or "colour"

# Grouping
grep -E "(ab)+" file.txt                # Match "ab", "abab", "ababab", etc.
grep -E "^(http|https)://" urls.txt     # Match URLs starting with http or https
```

### Common Regex Patterns

```bash
#!/bin/bash

# Function to validate and extract common patterns
extract_patterns() {
    local text_file=$1
    
    echo "Pattern Extraction from: $text_file"
    echo "===================================="
    
    # Email addresses
    echo "Email addresses:"
    grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$text_file" | sort | uniq
    
    # Phone numbers (US format)
    echo -e "\nPhone numbers:"
    grep -oE '\(?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}' "$text_file" | sort | uniq
    
    # IP addresses
    echo -e "\nIP addresses:"
    grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$text_file" | sort | uniq
    
    # URLs
    echo -e "\nURLs:"
    grep -oE 'https?://[a-zA-Z0-9./?=_%:-]*' "$text_file" | sort | uniq
    
    # Credit card numbers (basic pattern)
    echo -e "\nPotential credit card numbers:"
    grep -oE '\b[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}\b' "$text_file" | sort | uniq
    
    # Social Security Numbers
    echo -e "\nSSN patterns:"
    grep -oE '\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b' "$text_file" | sort | uniq
    
    # Dates (various formats)
    echo -e "\nDate patterns:"
    echo "MM/DD/YYYY format:"
    grep -oE '\b[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}\b' "$text_file" | sort | uniq
    echo "YYYY-MM-DD format:"
    grep -oE '\b[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}\b' "$text_file" | sort | uniq
}

# Function to validate data formats
validate_data() {
    local data_file=$1
    local data_type=$2
    
    case $data_type in
        "email")
            while IFS= read -r line; do
                if echo "$line" | grep -qE '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; then
                    echo "✓ Valid: $line"
                else
                    echo "✗ Invalid: $line"
                fi
            done < "$data_file"
            ;;
        "ip")
            while IFS= read -r line; do
                if echo "$line" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
                    # Additional validation for IP range
                    valid_ip=true
                    IFS='.' read -r a b c d <<< "$line"
                    for octet in $a $b $c $d; do
                        if [ "$octet" -gt 255 ]; then
                            valid_ip=false
                            break
                        fi
                    done
                    if [ "$valid_ip" = true ]; then
                        echo "✓ Valid IP: $line"
                    else
                        echo "✗ Invalid IP range: $line"
                    fi
                else
                    echo "✗ Invalid IP format: $line"
                fi
            done < "$data_file"
            ;;
        "phone")
            while IFS= read -r line; do
                if echo "$line" | grep -qE '^\(?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}$'; then
                    echo "✓ Valid phone: $line"
                else
                    echo "✗ Invalid phone: $line"
                fi
            done < "$data_file"
            ;;
    esac
}
```

## Advanced Text Processing

### Multi-tool Processing Pipelines

```bash
#!/bin/bash

# Function for comprehensive log analysis
comprehensive_log_analysis() {
    local log_file=$1
    local output_dir=${2:-"log_analysis"}
    
    mkdir -p "$output_dir"
    
    echo "Comprehensive Log Analysis: $log_file"
    echo "====================================="
    
    # 1. Extract and count error types
    echo "Analyzing error patterns..."
    grep -i error "$log_file" | \
    sed 's/.*ERROR[: ]*\([^,]*\).*/\1/' | \
    awk '{gsub(/^[ \t]+|[ \t]+$/, "", $0); print tolower($0)}' | \
    sort | uniq -c | sort -rn > "$output_dir/error_types.txt"
    
    # 2. Hourly activity analysis
    echo "Analyzing hourly activity..."
    awk '{print substr($1, 12, 2)}' "$log_file" | \
    sort -n | uniq -c | \
    awk '{printf "%02d:00 - %d events\n", $2, $1}' > "$output_dir/hourly_activity.txt"
    
    # 3. IP address analysis (if present)
    echo "Analyzing IP addresses..."
    grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$log_file" | \
    sort | uniq -c | sort -rn | head -20 > "$output_dir/top_ips.txt"
    
    # 4. User agent analysis (for web logs)
    echo "Analyzing user agents..."
    grep -oE '"[^"]*"[[:space:]]*$' "$log_file" | \
    sed 's/"//g' | sort | uniq -c | sort -rn | head -10 > "$output_dir/user_agents.txt"
    
    # 5. Response size statistics
    echo "Analyzing response sizes..."
    awk '{print $10}' "$log_file" | \
    grep -E '^[0-9]+$' | \
    awk '{
        sum += $1; 
        count++; 
        if($1 > max) max = $1; 
        if(min == 0 || $1 < min) min = $1
    } 
    END {
        printf "Count: %d\n", count;
        printf "Sum: %d bytes\n", sum;
        printf "Average: %.2f bytes\n", sum/count;
        printf "Min: %d bytes\n", min;
        printf "Max: %d bytes\n", max
    }' > "$output_dir/response_stats.txt"
    
    echo "Analysis complete. Results in: $output_dir/"
}

# Function for complex data transformation
transform_data_format() {
    local input_file=$1
    local transformation_type=$2
    local output_file=${3:-"transformed_data.txt"}
    
    case $transformation_type in
        "json_to_csv")
            # Simple JSON array to CSV conversion
            sed 's/^\[//; s/\]$//; s/},{/}\n{/g' "$input_file" | \
            sed 's/[{}"]//g' | \
            awk -F',' 'NR==1{for(i=1;i<=NF;i++) {split($i,a,":"); headers[i]=a[1]} for(i=1;i<=NF;i++) printf "%s%s", headers[i], (i==NF ? "\n" : ",")} {for(i=1;i<=NF;i++) {split($i,a,":"); printf "%s%s", a[2], (i==NF ? "\n" : ",")}}' > "$output_file"
            ;;
        "csv_to_fixed_width")
            # Convert CSV to fixed-width format
            awk -F',' '{
                printf "%-20s %-15s %-10s %-12s\n", $1, $2, $3, $4
            }' "$input_file" > "$output_file"
            ;;
        "normalize_whitespace")
            # Normalize all whitespace
            tr -s '[:space:]' ' ' < "$input_file" | \
            sed 's/^[ \t]*//; s/[ \t]*$//' > "$output_file"
            ;;
        "extract_quoted_strings")
            # Extract all quoted strings
            grep -oE '"[^"]*"' "$input_file" | \
            sed 's/"//g' | sort | uniq > "$output_file"
            ;;
    esac
    
    echo "Data transformed: $input_file -> $output_file (type: $transformation_type)"
}

# Function for statistical text analysis
statistical_text_analysis() {
    local text_file=$1
    local output_report=${2:-"text_stats.txt"}
    
    {
        echo "Statistical Text Analysis Report"
        echo "==============================="
        echo "File: $text_file"
        echo "Generated: $(date)"
        echo
        
        # Basic statistics
        echo "Basic Statistics:"
        echo "----------------"
        echo "Total lines: $(wc -l < "$text_file")"
        echo "Total words: $(wc -w < "$text_file")"
        echo "Total characters: $(wc -c < "$text_file")"
        echo "Average words per line: $(awk '{total += NF; count++} END {printf "%.2f", total/count}' "$text_file")"
        echo
        
        # Word frequency analysis
        echo "Top 20 Most Frequent Words:"
        echo "---------------------------"
        tr '[:upper:]' '[:lower:]' < "$text_file" | \
        tr -d '[:punct:]' | \
        tr -s '[:space:]' '\n' | \
        grep -v '^$' | \
        sort | uniq -c | sort -rn | head -20
        echo
        
        # Line length distribution
        echo "Line Length Distribution:"
        echo "------------------------"
        awk '{print length($0)}' "$text_file" | \
        sort -n | uniq -c | \
        awk '{printf "Length %3d: %d lines\n", $2, $1}' | head -15
        echo
        
        # Character frequency
        echo "Top 10 Character Frequencies:"
        echo "----------------------------"
        tr '[:upper:]' '[:lower:]' < "$text_file" | \
        fold -w1 | grep -v '^$' | sort | uniq -c | sort -rn | head -10
        
    } > "$output_report"
    
    echo "Statistical analysis complete: $output_report"
}
```

## Performance Optimization

### Efficient Text Processing

```bash
#!/bin/bash

# Function to benchmark text processing operations
benchmark_text_operations() {
    local large_file=$1
    local num_runs=${2:-3}
    
    echo "Benchmarking Text Operations on: $large_file"
    echo "============================================"
    
    # Test different approaches for counting lines
    echo "Line counting methods:"
    
    for method in "wc -l" "grep -c ''" "awk 'END{print NR}'"; do
        echo -n "$method: "
        total_time=0
        for ((i=1; i<=num_runs; i++)); do
            start_time=$(date +%s.%N)
            eval "$method $large_file" >/dev/null
            end_time=$(date +%s.%N)
            duration=$(echo "$end_time - $start_time" | bc -l)
            total_time=$(echo "$total_time + $duration" | bc -l)
        done
        avg_time=$(echo "scale=3; $total_time / $num_runs" | bc -l)
        echo "${avg_time}s average"
    done
    
    echo
    echo "Pattern matching methods:"
    
    # Test different grep approaches
    pattern="error"
    for method in "grep '$pattern'" "awk '/$pattern/'" "sed -n '/$pattern/p'"; do
        echo -n "$method: "
        total_time=0
        for ((i=1; i<=num_runs; i++)); do
            start_time=$(date +%s.%N)
            eval "$method $large_file" >/dev/null
            end_time=$(date +%s.%N)
            duration=$(echo "$end_time - $start_time" | bc -l)
            total_time=$(echo "$total_time + $duration" | bc -l)
        done
        avg_time=$(echo "scale=3; $total_time / $num_runs" | bc -l)
        echo "${avg_time}s average"
    done
}

# Function for memory-efficient processing
memory_efficient_processing() {
    local large_file=$1
    local operation=$2
    
    case $operation in
        "unique_lines")
            # Process large files without loading everything into memory
            echo "Finding unique lines in large file..."
            sort "$large_file" | uniq > "${large_file}.unique"
            ;;
        "top_frequent")
            # Find most frequent lines without excessive memory usage
            echo "Finding most frequent lines..."
            sort "$large_file" | uniq -c | sort -rn | head -100 > "${large_file}.frequent"
            ;;
        "sample_lines")
            # Get random sample of lines
            local sample_size=${3:-1000}
            echo "Sampling $sample_size lines..."
            shuf -n "$sample_size" "$large_file" > "${large_file}.sample"
            ;;
        "split_process")
            # Split file and process in parallel
            echo "Splitting file for parallel processing..."
            split -l 10000 "$large_file" "${large_file}_chunk_"
            
            # Process chunks in parallel
            for chunk in "${large_file}_chunk_"*; do
                (
                    echo "Processing chunk: $chunk"
                    # Example processing - count words
                    wc -w "$chunk" > "$chunk.result"
                ) &
            done
            wait
            
            # Combine results
            cat "${large_file}_chunk_"*.result > "${large_file}.combined_results"
            rm "${large_file}_chunk_"* 2>/dev/null || true
            ;;
    esac
}

# Function to optimize regular expressions
optimize_regex_performance() {
    local test_file=$1
    local pattern=$2
    
    echo "Regex Performance Optimization Test"
    echo "==================================="
    
    # Test different regex engines and options
    echo "Testing pattern: $pattern"
    echo
    
    # Basic grep
    echo -n "Basic grep: "
    time grep "$pattern" "$test_file" >/dev/null
    
    # Fixed string search (if applicable)
    echo -n "Fixed string (fgrep): "
    time fgrep "$pattern" "$test_file" >/dev/null 2>&1 || echo "Pattern not suitable for fixed string search"
    
    # Extended regex
    echo -n "Extended regex (egrep): "
    time egrep "$pattern" "$test_file" >/dev/null
    
    # Perl-compatible regex
    if command -v pcregrep >/dev/null; then
        echo -n "PCRE (pcregrep): "
        time pcregrep "$pattern" "$test_file" >/dev/null
    fi
    
    # GNU grep with specific options
    echo -n "GNU grep optimized: "
    time grep --mmap "$pattern" "$test_file" >/dev/null 2>&1 || \
    time grep "$pattern" "$test_file" >/dev/null
}
```

## Real-World Examples

### System Administration Scripts

```bash
#!/bin/bash

# Function to analyze system logs for security issues
security_log_analysis() {
    local log_files=("/var/log/auth.log" "/var/log/secure" "/var/log/syslog")
    local output_dir="security_analysis_$(date +%Y%m%d)"
    
    mkdir -p "$output_dir"
    
    echo "Security Log Analysis"
    echo "===================="
    
    for log_file in "${log_files[@]}"; do
        if [ -f "$log_file" ]; then
            echo "Analyzing: $log_file"
            
            # Failed login attempts
            grep -i "failed\|failure" "$log_file" | \
            awk '{print $1, $2, $3, $9, $11}' | \
            sort | uniq -c | sort -rn > "$output_dir/failed_logins_$(basename "$log_file").txt"
            
            # Successful root logins
            grep -i "accepted.*root" "$log_file" | \
            awk '{print $1, $2, $3, $9, $11}' > "$output_dir/root_logins_$(basename "$log_file").txt"
            
            # SSH brute force attempts
            grep "sshd.*Failed password" "$log_file" | \
            awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | \
            head -20 > "$output_dir/ssh_brute_force_$(basename "$log_file").txt"
            
            # Sudo usage
            grep "sudo:" "$log_file" | \
            awk '{print $1, $2, $3, $5, $6}' | \
            sort | uniq -c > "$output_dir/sudo_usage_$(basename "$log_file").txt"
        fi
    done
    
    # Generate summary report
    {
        echo "Security Analysis Summary - $(date)"
        echo "=================================="
        echo
        
        echo "Top Failed Login Sources:"
        cat "$output_dir"/failed_logins_*.txt 2>/dev/null | \
        awk '{ip=$(NF); count=$1} {total[ip] += count} END {for (ip in total) print total[ip], ip}' | \
        sort -rn | head -10
        
        echo -e "\nRoot Login Summary:"
        cat "$output_dir"/root_logins_*.txt 2>/dev/null | wc -l
        echo " total root login attempts found"
        
        echo -e "\nTop Brute Force Sources:"
        cat "$output_dir"/ssh_brute_force_*.txt 2>/dev/null | head -10
        
    } > "$output_dir/security_summary.txt"
    
    echo "Analysis complete. Results in: $output_dir/"
}

# Function to monitor application performance from logs
application_performance_monitor() {
    local app_log=$1
    local time_window=${2:-"1 hour"}
    local output_file=${3:-"performance_report.txt"}
    
    echo "Application Performance Monitoring"
    echo "================================="
    
    # Calculate time range
    case $time_window in
        "1 hour")
            cutoff_time=$(date -d '1 hour ago' '+%Y-%m-%d %H:%M:%S')
            ;;
        "24 hours")
            cutoff_time=$(date -d '1 day ago' '+%Y-%m-%d %H:%M:%S')
            ;;
        "1 week")
            cutoff_time=$(date -d '1 week ago' '+%Y-%m-%d %H:%M:%S')
            ;;
    esac
    
    {
        echo "Performance Report - Last $time_window"
        echo "======================================"
        echo "Generated: $(date)"
        echo "Log file: $app_log"
        echo
        
        # Response time analysis (assuming response times are logged)
        echo "Response Time Analysis:"
        grep "response_time" "$app_log" | \
        awk -v cutoff="$cutoff_time" '$1 " " $2 >= cutoff {print $NF}' | \
        awk '{
            sum += $1; 
            count++; 
            if ($1 > max) max = $1; 
            if (min == 0 || $1 < min) min = $1;
            
            # Response time buckets
            if ($1 < 100) fast++;
            else if ($1 < 500) medium++;
            else if ($1 < 1000) slow++;
            else very_slow++;
        } 
        END {
            printf "Total requests: %d\n", count;
            printf "Average response time: %.2f ms\n", sum/count;
            printf "Min response time: %.2f ms\n", min;
            printf "Max response time: %.2f ms\n", max;
            printf "Fast (<100ms): %d (%.1f%%)\n", fast, (fast/count)*100;
            printf "Medium (100-500ms): %d (%.1f%%)\n", medium, (medium/count)*100;
            printf "Slow (500-1000ms): %d (%.1f%%)\n", slow, (slow/count)*100;
            printf "Very slow (>1000ms): %d (%.1f%%)\n", very_slow, (very_slow/count)*100;
        }'
        
        echo
        echo "Error Rate Analysis:"
        
        # HTTP status code analysis
        grep -oE 'HTTP/[0-9.]+ [0-9]{3}' "$app_log" | \
        awk -v cutoff="$cutoff_time" '$1 " " $2 >= cutoff {print $2}' | \
        awk '{
            status_codes[$1]++;
            total++;
            if ($1 >= 400) errors++;
        } 
        END {
            printf "Total HTTP requests: %d\n", total;
            printf "Error requests (4xx/5xx): %d (%.2f%%)\n", errors, (errors/total)*100;
            printf "\nStatus code breakdown:\n";
            for (code in status_codes) {
                printf "%s: %d (%.1f%%)\n", code, status_codes[code], (status_codes[code]/total)*100;
            }
        }'
        
        echo
        echo "Most frequent errors:"
        grep -i error "$app_log" | \
        awk -v cutoff="$cutoff_time" '$1 " " $2 >= cutoff' | \
        awk '{$1=""; $2=""; $3=""; print $0}' | \
        sort | uniq -c | sort -rn | head -10
        
    } > "$output_file"
    
    echo "Performance report generated: $output_file"
}

# Function for data processing pipeline
data_processing_pipeline() {
    local raw_data=$1
    local config_file=${2:-"pipeline.conf"}
    local output_dir=${3:-"processed_data"}
    
    mkdir -p "$output_dir"
    
    echo "Data Processing Pipeline"
    echo "======================="
    
    # Stage 1: Data cleaning
    echo "Stage 1: Cleaning data..."
    sed '
        # Remove empty lines
        /^$/d
        
        # Remove comments
        /^#/d
        
        # Normalize whitespace
        s/^[ \t]*//
        s/[ \t]*$//
        s/[ \t]\+/ /g
        
    ' "$raw_data" > "$output_dir/cleaned_data.txt"
    
    # Stage 2: Data validation
    echo "Stage 2: Validating data..."
    awk '
    BEGIN {
        valid_count = 0
        invalid_count = 0
        FS = ","
    }
    {
        # Basic validation rules
        if (NF >= 3 && $1 != "" && $2 != "" && $3 ~ /^[0-9]+$/) {
            print $0 > "'$output_dir'/valid_data.csv"
            valid_count++
        } else {
            print $0 > "'$output_dir'/invalid_data.csv"
            invalid_count++
        }
    }
    END {
        printf "Validation complete:\n"
        printf "Valid records: %d\n", valid_count
        printf "Invalid records: %d\n", invalid_count
        printf "Success rate: %.2f%%\n", (valid_count/(valid_count+invalid_count))*100
    }' "$output_dir/cleaned_data.txt"
    
    # Stage 3: Data transformation
    echo "Stage 3: Transforming data..."
    awk -F, '
    BEGIN {
        OFS = ","
        print "id,name,category,value,processed_date"
    }
    {
        # Transform and enrich data
        id = $1
        name = toupper($2)
        category = $3
        value = $4 * 1.1  # Apply 10% increase
        processed_date = strftime("%Y-%m-%d", systime())
        
        print id, name, category, value, processed_date
    }' "$output_dir/valid_data.csv" > "$output_dir/transformed_data.csv"
    
    # Stage 4: Generate summary statistics
    echo "Stage 4: Generating statistics..."
    awk -F, '
    NR > 1 {  # Skip header
        category_sum[$3] += $4
        category_count[$3]++
        total_sum += $4
        total_count++
    }
    END {
        print "Data Processing Summary"
        print "======================"
        printf "Total records processed: %d\n", total_count
        printf "Total value: %.2f\n", total_sum
        printf "Average value: %.2f\n", total_sum/total_count
        
        print "\nBy Category:"
        for (cat in category_sum) {
            printf "%-15s: %d records, total %.2f, average %.2f\n", 
                   cat, category_count[cat], category_sum[cat], 
                   category_sum[cat]/category_count[cat]
        }
    }' "$output_dir/transformed_data.csv" > "$output_dir/processing_summary.txt"
    
    echo "Pipeline complete. Output in: $output_dir/"
}
```

This comprehensive guide provides detailed coverage of Linux text processing tools and techniques. Master these tools to become proficient in data manipulation and analysis from the command line.
