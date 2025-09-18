# Shell Scripting Guide

## Introduction to Shell Scripting

A shell script is a command-line program that contains a series of commands for a computer to execute. It can be used to automate repetitive tasks, making your workflow more efficient. Shell scripts are written in a scripting language that is interpreted by a shell, such as Bash (Bourne Again SHell), which is the default shell for most Linux distributions.

### Why Use Shell Scripting?

- **Automation:** Automate repetitive tasks, such as backups, system monitoring, and file management.
- **Customization:** Create custom commands and workflows tailored to your specific needs.
- **Efficiency:** Execute a series of commands with a single script, saving time and effort.

## Getting Started

### Creating a Shell Script

To create a shell script, you need to create a new file with a `.sh` extension. For example, `my_script.sh`.

The first line of a shell script should be the "shebang" line, which specifies the interpreter to be used. For Bash, this is:

```bash
#!/bin/bash
```

### Making the Script Executable

Before you can run a shell script, you need to make it executable. You can do this using the `chmod` command:

```bash
chmod +x my_script.sh
```

### Running a Shell Script

To run a shell script, you can execute it from the terminal:

```bash
./my_script.sh
```

## Variables

Variables are used to store data in a shell script. You can define a variable by assigning a value to it:

```bash
# Variable assignment
name="John"
age=30

# Accessing variables
echo "My name is $name and I am $age years old."
```

## User Input

You can prompt the user for input using the `read` command:

```bash
#!/bin/bash

echo "What is your name?"
read name
echo "Hello, $name!"
```

## Conditional Statements

Conditional statements allow you to execute different blocks of code based on certain conditions.

### `if-elif-else`

The `if-elif-else` statement is used to test conditions:

```bash
#!/bin/bash

read -p "Enter a number: " num

if [ $num -gt 0 ]; then
  echo "The number is positive."
elif [ $num -lt 0 ]; then
  echo "The number is negative."
else
  echo "The number is zero."
fi
```

## Loops

Loops are used to execute a block of code multiple times.

### `for` Loop

The `for` loop iterates over a list of items:

```bash
#!/bin/bash

for i in 1 2 3 4 5; do
  echo "Number: $i"
done
```

### `while` Loop

The `while` loop continues as long as a condition is true:

```bash
#!/bin/bash

count=1
while [ $count -le 5 ]; do
  echo "Count: $count"
  ((count++))
done
```

## Functions

Functions are reusable blocks of code that can be called from anywhere in your script.

```bash
#!/bin/bash

# Function definition
greet() {
  echo "Hello, $1!"
}

# Calling the function
greet "Alice"
greet "Bob"
```

This guide provides a basic overview of shell scripting. With these fundamentals, you can start writing your own scripts to automate tasks and improve your productivity in the Linux environment.
