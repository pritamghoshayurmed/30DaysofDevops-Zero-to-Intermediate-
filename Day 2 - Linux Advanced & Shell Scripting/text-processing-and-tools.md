# Text Processing and Tools in Linux

## Introduction

Linux provides a powerful set of command-line tools for processing text. These tools are essential for system administrators, developers, and power users to manipulate and analyze text-based data and files. This guide covers some of the most common text processing tools: `grep`, `sed`, and `awk`.

## `grep` (Global Regular Expression Print)

`grep` is a command-line utility for searching plain-text data sets for lines that match a regular expression.

### Basic Syntax

`grep [options] pattern [file...]`

### Common Options

-   `-i`: Case-insensitive search.
-   `-v`: Invert the match (select non-matching lines).
-   `-r` or `-R`: Recursively search directories.
-   `-l`: Print only the names of files with matching lines.
-   `-c`: Print only a count of matching lines.
-   `-n`: Prefix each line of output with the line number.

### Examples

-   Search for "error" in a log file:
    `grep "error" /var/log/syslog`
-   Case-insensitively search for "user" in all files in the current directory:
    `grep -i "user" *`
-   Find all lines that do not contain "debug":
    `grep -v "debug" app.log`

## `sed` (Stream Editor)

`sed` is a powerful tool for performing text transformations on an input stream (a file or input from a pipeline). It can perform basic text substitutions, deletions, insertions, and more.

### Basic Syntax

`sed [options] 'command' [file...]`

### Common Commands

-   `s/regexp/replacement/`: Substitute the first match of `regexp` with `replacement`.
-   `s/regexp/replacement/g`: Substitute all matches of `regexp` with `replacement`.
-   `/pattern/d`: Delete lines matching `pattern`.
-   `'N; s/\n/ /'`: Join the next line to the current one, useful for multi-line operations.

### Examples

-   Replace all occurrences of "foo" with "bar" in a file:
    `sed 's/foo/bar/g' myfile.txt`
-   Delete all lines containing "tmp":
    `sed '/tmp/d' myfile.txt`
-   Comment out lines starting with "debug":
    `sed 's/^debug/#&/' app.log`

## `awk`

`awk` is a versatile programming language designed for text processing. It processes files line by line and is particularly good at handling structured, column-based data.

### Basic Syntax

`awk 'pattern { action }' [file...]`

### How it Works

`awk` reads the input line by line. For each line, it checks if it matches the `pattern`. If it does, `awk` performs the `action`. If no pattern is provided, the action is performed for every line.

### Built-in Variables

-   `$0`: The entire current line.
-   `$1`, `$2`, ...: The first, second, ... field (column) of the current line.
-   `NF`: The number of fields in the current line.
-   `NR`: The number of the current record (line number).

### Examples

-   Print the first column of a file (fields are separated by whitespace by default):
    `awk '{print $1}' data.txt`
-   Print the third and second columns, separated by a comma:
    `awk '{print $3, $2}' data.txt`
-   Print lines where the third column is greater than 50:
    `awk '$3 > 50 {print $0}' data.txt`
-   Calculate the sum of the values in the first column:
    `awk '{sum += $1} END {print sum}' numbers.txt`

## Combining Tools with Pipes

The true power of these tools comes from combining them using pipes (`|`). The output of one command can be used as the input for another.

### Example

Find all error messages in a log file from a specific date, and extract the timestamp and the error message itself:

`grep "2023-09-18" /var/log/app.log | grep "ERROR" | awk '{print $1, $2, $5}'`

This command chain:
1.  `grep "2023-09-18"`: Filters for lines containing the date.
2.  `grep "ERROR"`: Filters the result for lines also containing "ERROR".
3.  `awk '{print $1, $2, $5}'`: Prints the first, second, and fifth fields from the remaining lines, which might correspond to the date, time, and error message.

By mastering `grep`, `sed`, and `awk`, you can perform complex text manipulation and data extraction tasks directly from the command line.
